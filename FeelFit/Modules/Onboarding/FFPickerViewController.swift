//
//  FFPickerViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 13.03.2024.
//

import UIKit

class FFPickerViewController: UIViewController {
    
    private var pickerData: [String]?
    private var tableViewIndex: Int
    private var blurEffect: UIBlurEffect.Style?
    private var vibrancyEffect: UIVibrancyEffectStyle?
    
    var selectedValue: String?
    
    //Доделать инициализатор
    //Должен брать на вход опциональные данные в случае если они имеются и выбирать уже существующий кейс из enum
    init(tableViewIndex: Int, blurEffectStyle: UIBlurEffect.Style?, vibrancyEffect: UIVibrancyEffectStyle?) {
        self.tableViewIndex = tableViewIndex
        self.blurEffect = blurEffectStyle
        self.vibrancyEffect = vibrancyEffect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let pickerView : UIPickerView = UIPickerView(frame: .zero)
    
    private let datePickerView: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.preferredDatePickerStyle = .wheels
        picker.timeZone = TimeZone.current
        picker.datePickerMode = .date
        picker.isHidden = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        enumProvider(tableViewIndex)
    }
    
    func enumProvider(_ index: Int) {
        switch index {
        case 0:
            setupDisplayDatePickerView(true)
            pickerData = nil
        case 1:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.GenderTypeResult.allCases.compactMap({ $0.rawValue })
        case 2:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.BloodTypeResult.allCases.compactMap({ $0.rawValue })
        case 3:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.FitzpatricSkinTypeResult.allCases.compactMap({ $0.rawValue })
        case 4:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.WheelchairTypeResult.allCases.compactMap({ $0.rawValue })
        default:
            setupDisplayDatePickerView(false)
            fatalError("Invalid index. Try again later")
        }
    }
    
    private func setupDisplayDatePickerView(_ isDatePickerPresented: Bool) {
        if isDatePickerPresented {
            datePickerView.isHidden = false
            pickerView.isHidden = true
        } else {
            datePickerView.isHidden = true
            pickerView.isHidden = false
        }
    }
}

extension FFPickerViewController: SetupViewController {
    func setupView() {
        setupNavigationController()
        setupViewModel()
        setupPickerView()
        view.backgroundColor = .clear
//        setupBlurEffectBackgroundView(blurEffect, vibrancyEffect)
        
        let vbe = UIVisualEffectView(effect: UIBlurEffect(style: blurEffect ?? .regular))
        vbe.frame = view.bounds
        view.addSubview(vbe)
        
        setupConstraints()
        
    }
    
    private func setupDatePickerView(){
        datePickerView.tintColor = .customBlack
        datePickerView.backgroundColor = .clear
    }
    
    private func setupPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .clear
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44))
        label.numberOfLines = 1
        label.contentMode = .scaleAspectFit
        label.font = UIFont.detailLabelFont(size: 20)
        label.text = pickerData?[row]
        label.textAlignment = .center
        label.textColor = .customBlack
        return label
    }
}

extension FFPickerViewController: UIPickerViewDelegate {
    
}

extension FFPickerViewController {
    private func setupConstraints(){
        let height = view.frame.size.height/2
        
        preferredContentSize = CGSize(width: view.frame.size.width, height: height )
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
        
        view.addSubview(datePickerView)
        datePickerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
       
        
    }
}

#Preview {
    let navVC = UINavigationController(rootViewController: FFPickerViewController(tableViewIndex: 0, blurEffectStyle: .regular, vibrancyEffect: .fill))
    navVC.modalPresentationStyle = .pageSheet
    navVC.sheetPresentationController?.detents = [.custom(resolver: { context in
        return 300.0
    })]
    navVC.sheetPresentationController?.prefersGrabberVisible = true
    return navVC
}

