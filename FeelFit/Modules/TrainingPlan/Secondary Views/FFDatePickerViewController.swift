//
//  FFDatePickerViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 08.12.2023.
//

import UIKit

class FFDatePickerViewController: UIViewController, SetupViewController {
    
    var handler: ((Date,Bool) -> ())?
    
    private let chosenDate: Date
    init(chosenDate: Date) {
        self.chosenDate = chosenDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupDatePicker()
        setupConstraints()
    }
    
    private func setupDatePicker(){
        datePicker = UIDatePicker(frame: .zero)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .clear
        datePicker.setDate(chosenDate, animated: true)
        datePicker.tintColor = FFResources.Colors.activeColor
        datePicker.locale = .current
        datePicker.timeZone = TimeZone.current
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    @objc private func didTapDismiss(){
        let date = datePicker.date
        
        alertControllerActionConfirm(title: "Warning", message: "Do you want add notification on chosen date?", confirmActionTitle: "Add Notification", secondTitleAction: "Don't add", style: .alert) { [unowned self] in
            handler?(date,true)
            dismiss(animated: true)
        } secondAction: { [unowned self] in
            handler?(date,false)
            self.dismiss(animated: true)
        }
    }
    
    func setupNavigationController() {
        title = "Select Date"
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFDatePickerViewController {
    private func setupConstraints(){
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
