//
//  FFExercisesMuscleTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 01.11.2023.
//

import UIKit
import RealmSwift

class FFExercisesMuscleTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath!
    
    static let identifier = "FFExercisesMuscleTableViewCell"
    
    var exercise: Exercise!
    
    private let realm = try! Realm()
    private let storeManager = FFFavouriteExerciseStoreManager.shared
    
    var status: Bool!
    
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = FFResources.Colors.textColor
        label.font = .textLabelFont(weight: UIFont.Weight.regular)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    
    private let detailLabel: UILabel = {
       let label = UILabel()
        label.textColor = FFResources.Colors.detailTextColor
        label.font = .detailLabelFont(weight: UIFont.Weight.thin)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    
    private let actionFavouriteImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.tintColor = FFResources.Colors.activeColor
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupImageViewInteraction()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapOnImage(){
        status.toggle()
        if status {
            changeImageWith(image: "heart.fill") { [unowned self] in
                try! storeManager.saveExercise(exercise: exercise)
            }
        } else {
            changeImageWith(image: "heart") { [unowned self] in
                storeManager.deleteExerciseWith(model: exercise)
            }
        }
    }
    
    func configureView(keyName: String, exercise: Exercise, indexPath: IndexPath,isSearching: Bool){
        checkModelStatus(model: exercise)
        self.exercise = exercise
        self.mainLabel.text = exercise.exerciseName.capitalized
        self.detailLabel.text = "Muscles: " + exercise.muscle.formatArrayText() + "Sec: " + exercise.secondaryMuscles.joined(separator: ", ").formatArrayText()
        self.actionFavouriteImageView.tag = indexPath.row
        if status {
            self.actionFavouriteImageView.image = UIImage(systemName: "heart.fill")
        } else {
            self.actionFavouriteImageView.image = UIImage(systemName: "heart")
        }
        changeLabelsConstraints(status: isSearching)
    }
    
    func changeLabelsConstraints(status: Bool){
        if !status {
            actionFavouriteImageView.isHidden = true
            actionFavouriteImageView.removeFromSuperview()
            mainLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview().offset(3)
                make.trailing.equalToSuperview().offset(10)
                make.height.equalTo(contentView.frame.size.height/2)
            }
            detailLabel.snp.remakeConstraints { make in
                make.top.equalTo(mainLabel.snp.bottom)
                make.leading.equalToSuperview().offset(3)
                make.trailing.bottom.equalToSuperview().offset(3)
            }
            self.contentView.layoutIfNeeded()
        } else {
            actionFavouriteImageView.isHidden = false
        }
    }
    
    private func updateSelectedInterface(){
        self.alpha = isSelected ? 0.7 : 1
        self.accessoryType = isSelected ? .checkmark : .none
        actionFavouriteImageView.alpha = isSelected ? 0.7 : 1
    }
    
    private func changeImageWith(image name: String, action: @escaping () -> ()){
        let image = actionFavouriteImageView
        UIView.transition(with: image, duration: 0.3, options: .transitionCrossDissolve) {
            self.actionFavouriteImageView.image = UIImage(systemName: name)
        } completion: { _ in
            action()
        }
    }

    private func setupCell(){
        self.accessoryType = .disclosureIndicator
    }
    
    private func setupImageViewInteraction(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnImage))
        actionFavouriteImageView.addGestureRecognizer(gesture)
    }
    
    private func checkModelStatus(model: Exercise){
        let object = realm.objects(FFFavouriteExerciseRealmModel.self).filter("exerciseID == %@",model.exerciseID)
        status = !object.isEmpty ? true : false
    }
    
    
    private func setupConstraints(){
        contentView.addSubview(actionFavouriteImageView)
        actionFavouriteImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(3)
            make.width.equalTo(self.snp.height).inset(3)
        }
        contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(actionFavouriteImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(10)
        }
        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom)
            make.leading.equalTo(actionFavouriteImageView.snp.trailing).offset(10)
            make.trailing.bottom.equalToSuperview().offset(10)
        }
    }
    
}
