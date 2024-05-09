//
//  FFHealthUserInformationViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.02.2024.
//

import UIKit

class FFHealthUserInformationViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFHealthUserInformationViewModel!
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    //MARK: - Action methods
    @objc private func didTapDismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSaveUserData(){
        viewModel.saveUserData()
    
    }
    
    //MARK: - Set up methods
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupViewModel()

        setupTableView()
        setupNavigationController()
        setupConstraints()
        
    }
    
    
    func setupViewModel() {
        viewModel = FFHealthUserInformationViewModel(viewController: self)
        viewModel.delegate = self
        viewModel.loadFullUserData()
    }

    func setupNavigationController() {
        title = "Health information"
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapDismiss), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Save", imageName: "", action: #selector(didTapSaveUserData), menu: nil)
    }

    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FFSubtitleTableViewCell.self, forCellReuseIdentifier: FFSubtitleTableViewCell.identifier)
        tableView.register(FFCenteredTitleTableViewCell.self, forCellReuseIdentifier: FFCenteredTitleTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

//MARK: - Table view data source
extension FFHealthUserInformationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0,1:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFSubtitleTableViewCell.identifier, for: indexPath) as! FFSubtitleTableViewCell
            cell.configureLabels(value: viewModel.userData, indexPath: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFCenteredTitleTableViewCell.identifier, for: indexPath) as! FFCenteredTitleTableViewCell
            cell.configureCell( indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - Table view delegate
extension FFHealthUserInformationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    //Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension FFHealthUserInformationViewController: HealthUserInformationDelegate {
    func didReloadTableView(indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.reloadRows(at: [indexPath], with: .fade)
        } else {
            tableView.reloadData()
        }
        
    }
    
    
}

private extension FFHealthUserInformationViewController {
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

#Preview {
    let navVC = FFNavigationController(rootViewController: FFHealthUserInformationViewController())
    return navVC
}
