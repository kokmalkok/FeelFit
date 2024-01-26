//
//  FFHealthUserProfileViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 25.01.2024.
//

import UIKit

class FFHealthUserProfileViewController: UIViewController, SetupViewController {
    
    private let headerTextSections = [
        "",
        "Functions",
        "Сonfidentiality",
        ""
    ]
    
    private let textLabelRows = [
        ["Health information"
         ,"Medical Card"],
        ["Health Checklist",
         "Notification"],
        ["Application and services",
         "Scientific Research",
        "Devices"],
        ["Export Medical Data"]
    ]
    
    private let imagePicker = UIImagePickerController()
    
    private var scrollView: UIScrollView = UIScrollView(frame: .zero)
    private var userImageView: UIImageView = UIImageView(frame: .zero)
    private var userFullNameLabel: UILabel = UILabel(frame: .zero)
    private var tableView: UITableView = UITableView(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    //MARK: - Target methods
    @objc private func didTapDismiss(){
        self.dismiss(animated: true)
    }
    
    @objc private func didTapOpenImagePicker(_ gesture: UITapGestureRecognizer){
        let vc = UIImagePickerController()
        
    }
    
    private func openImagePicker(_ sourceType: UIImagePickerController.SourceType){
        
    }
    
    private func selectedSize(_ size: UIImagePickerController){
        
    }
    
    private func selectImageSizeMenu(){
        let image = UIImage(systemName: "photo.fill")
        
        let children = [
            UIAction(title: "Small", handler: { [weak self] _ in
                
            }),
            UIAction(title: "Medium", handler: { [weak self] _ in
                
            }),
            UIAction(title: "Large", handler: { [weak self] _ in
                
            })
        ]
        
        let menu = UIMenu(title: "Size", subtitle: "Select image size", image: image,children: children)
    }
    
    
    //MARK: Set up methods
    func setupImagePickerView(){
        imagePicker.delegate = self
    }
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupUserLabel()
        setupUserImageView()
        setupScrollView()
        setupImagePickerView()
        setupConstraints()
    }
    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        FFNavigationController().navigationBar.backgroundColor = .secondarySystemBackground
    }
    
    func setupViewModel() {
        
    }
    
    private func setupUserImageView(){
        userImageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        userImageView.tintColor = FFResources.Colors.activeColor
        userImageView.isUserInteractionEnabled = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOpenImagePicker))
        userImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupUserLabel(){
        userFullNameLabel = UILabel(frame: .zero)
        userFullNameLabel.text = "Malkov Konstantin"
        userFullNameLabel.font = UIFont.headerFont(size: 24)
        userFullNameLabel.textAlignment = .center
        userFullNameLabel.numberOfLines = 1
    }
    
    private func setupScrollView(){
        scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userHealthCell")
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 44
    }
}

extension FFHealthUserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
}

extension FFHealthUserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        headerTextSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textLabelRows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userHealthCell", for: indexPath)
        cell.backgroundColor = .systemBackground
        cell.textLabel?.text = textLabelRows[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension FFHealthUserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: tableView.frame.width-10, height: 34))
        label.font = UIFont.textLabelFont(size: 24)
        label.text = headerTextSections[section]
        label.textAlignment = .left
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        customView.addSubview(label)
        return customView
    }
}

extension FFHealthUserProfileViewController {
    private func setupConstraints(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let imageSize = view.frame.size.width/5
        
        scrollView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(imageSize)
        }
        
        scrollView.addSubview(userFullNameLabel)
        userFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userFullNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.8)
            make.height.lessThanOrEqualToSuperview().multipliedBy(2)
            make.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width)
        }
        
    }
}
