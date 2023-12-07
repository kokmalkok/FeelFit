//
//  FFAddExerciseViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 29.11.2023.
//

import UIKit
import Kingfisher




/// Class for adding exercises to created base program plan
class FFAddExerciseViewController: UIViewController, SetupViewController {
    
    
    
    private var viewModel: FFAddExerciseViewModel!
    
    private let trainProgram: CreateTrainProgram?
    private var exercises = [Exercise]()
    
    init(trainProgram: CreateTrainProgram?) {
        self.trainProgram = trainProgram
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupNavigationController()
        setupTableView()
        if exercises.isEmpty {
            contentUnavailableConfiguration =  viewModel.configureView { [unowned self] in
                didTapAddExercise()
            }
        } else {
            setupNonEmptyValue()
        }
    }
    
    //MARK: - Target methods
    @objc private func didTapAddExercise(){
        let vc = FFMuscleGroupSelectionViewController()
        vc.delegate = self
        viewModel.addExercise(vc: vc)
    }
    
    @objc private func didTapSave(){
        alertControllerActionConfirm(title: "Warning", message: "Save created program?", confirmActionTitle: "Save", style: .actionSheet) { [unowned self] in
            print("Saved in realm database")
            navigationController?.popToRootViewController(animated: true)
        } secondAction: { [unowned self] in
            print("not saved in realm")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - Setup View methods
    func configureUnavailableContent(action: @escaping () -> ()) -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No exercises"
        config.image = UIImage(systemName: "figure.strengthtraining.traditional")
        config.button = .plain()
        config.button.image = UIImage(systemName: "plus")
        config.button.baseForegroundColor = FFResources.Colors.activeColor
        config.button.title = "Add exercise"
        config.button.imagePlacement = .leading
        config.button.imagePadding = 2
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            action()
        })
        return config
    }
    
    func setupViewModel() {
        viewModel = FFAddExerciseViewModel(viewController: self)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "exerciseCell")
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    func setupNavigationController() {
        title = "Exercises"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setLeftBarButton(addNavigationBarButton(title: "Save", imageName: "", action: #selector(didTapSave), menu: nil), animated: true)
        
    }
    
    func setupNonEmptyValue(){
        setupConstraints()
        navigationItem.setRightBarButton(addNavigationBarButton(title: "Add", imageName: "plus", action: #selector(didTapAddExercise), menu: nil), animated: true)
    }
    
    func loadImage(_ link: String,handler: @escaping ((Data) -> ())){
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { data ,_,_ in
            if let data = data {
                handler(data)
            }
        }.resume()
    }
}

extension FFAddExerciseViewController: PlanExerciseDelegate {
    func deliveryData(exercises: [Exercise]) {
        self.exercises.append(contentsOf: exercises)
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
            setupNonEmptyValue()
        }
    }
    
    
}

extension FFAddExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "exerciseCell")
        let exercise = exercises[indexPath.row]
        cell.textLabel?.text = "Name: " + exercise.exerciseName
        cell.detailTextLabel?.text = "Muscle: " + exercise.muscle
        loadImage(exercise.imageLink) { data in
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data) ?? UIImage(systemName: "figure.strengthtraining.traditional")
                cell.imageView?.tintColor = FFResources.Colors.activeColor
            }
        }
        return cell
    }
}

extension FFAddExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exercise = exercises[indexPath.row]
        let vc = FFExerciseDescriptionViewController(exercise: exercise)
        dump(exercise)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FFAddExerciseViewController {
    private func setupConstraints(){
        contentUnavailableConfiguration = nil
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UIViewController {
    func alertControllerActionConfirm(title: String?, message: String?,confirmActionTitle: String,style: UIAlertController.Style,action: @escaping () -> (), secondAction: @escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default) { _ in
            action()
        }
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            secondAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
