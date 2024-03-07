//
//  FFOnboardingAuthenticationViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit

class FFOnboardingAuthenticationViewController: UIViewController, SetupViewController {
    
    private var isPasswordHidden: Bool = true
    private let accountManager = FFUserAccountManager.shared
    
    private let loginUserLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Login"
        label.font = UIFont.headerFont(for: .title1)
        label.textAlignment = .center
        label.contentMode = .scaleToFill
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let authStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.contentMode = .scaleAspectFit
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let userEmailTextField: UITextField = {
        let leftCustomView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let textfield = UITextField(frame: .zero)
        textfield.leftView = leftCustomView
        textfield.leftViewMode = .always
        textfield.autocapitalizationType = .none
        textfield.placeholder = "Your Email"
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.font = UIFont.headerFont(for: .body)
        textfield.adjustsFontForContentSizeCategory = true
        textfield.textColor = FFResources.Colors.customBlack
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .asciiCapable
        textfield.returnKeyType = .continue
        return textfield
    }()
    
    private let userPasswordTextField: UITextField = {
        let leftCustomView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let textfield = UITextField(frame: .zero)
        textfield.leftView = leftCustomView
        textfield.leftViewMode = .always
        textfield.rightViewMode = .always
        textfield.autocapitalizationType = .none
        textfield.placeholder = "Your Password"
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.font = UIFont.headerFont(for: .body)
        textfield.adjustsFontForContentSizeCategory = true
        textfield.textColor = FFResources.Colors.customBlack
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .asciiCapable
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        return textfield
    }()
    
    private let changePasswordSecureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = FFResources.Colors.customBlack
        button.contentMode = .left
        return button
    }()
    
    private var userConfirmPassword = CustomConfigurationButton(
        configurationTitle: "Continue",
        configurationImagePlacement: .leading
    )
    
    private let savePasswordButton = CustomConfigurationButton(configurationTitle: "Save account")
    private let readAccount = CustomConfigurationButton(configurationTitle: "Check account")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func confirmUserAccount(){
        print("Register")
    }
    
    @objc private func didTapSave(){
        guard let email = userEmailTextField.text else {
            return
        }
        
        guard let password = userPasswordTextField.text else {
            return
        }
        do {
            try accountManager.save(userData: CredentialUser(email: email, password: password))
            confirmButton(savePasswordButton, completed: true)
        } catch let error as KeychainError {
            viewAlertController(text: error.errorDescription, startDuration: 0.5, timer: 4, controllerView: self.view)
        } catch {
            viewAlertController(text: "Fatal error", startDuration: 0.5, timer: 4, controllerView: self.view)
            confirmButton(savePasswordButton, completed: false)
        }
    }
    
    
    
    @objc private func didTapRead(){
        guard let email = userEmailTextField.text else {
            return
        }
        
        guard let password = userPasswordTextField.text else {
            return
        }
        
        do {
            try accountManager.read(userData: CredentialUser(email: email, password: password))
            confirmButton(readAccount, completed: true)
        } catch let error as KeychainError {
            viewAlertController(text: error.errorDescription, startDuration: 0.5, timer: 4, controllerView: self.view)
        } catch {
            viewAlertController(text: "Fatal error", startDuration: 0.5, timer: 4, controllerView: self.view)
        }
    }
    
    private func confirmButton(_ button: UIButton,completed: Bool){
        if completed {
            button.configuration?.baseBackgroundColor = .systemGreen
            button.configuration?.title = "Success"
            button.isEnabled = false
        } else {
            button.configuration?.baseBackgroundColor = .systemRed
            button.configuration?.title = "Error. Try again"
            button.isEnabled = true
        }
    }
    
    private func changePasswordSecureAction(){
        if isPasswordHidden {
            isPasswordHidden.toggle()
            userPasswordTextField.isSecureTextEntry = false
            changePasswordSecureButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            isPasswordHidden.toggle()
            userPasswordTextField.isSecureTextEntry = true
            changePasswordSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
}

extension FFOnboardingAuthenticationViewController {
    
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupUserConfirmButton()
        setupTextFields()
        setupNavigationController()
        setupViewModel()
        setupConstraints()
    }
    
    private func setupUserConfirmButton(){
        let confirmUserAccountAction = UIAction { [weak self] _ in
            self?.confirmUserAccount()
        }
        
        userConfirmPassword.addAction(confirmUserAccountAction, for: .primaryActionTriggered)
        
        savePasswordButton.addTarget(self, action: #selector(didTapSave), for: .primaryActionTriggered)
        readAccount.addTarget(self, action: #selector(didTapRead), for: .primaryActionTriggered)
    }
    
    private func setupTextFields(){
        userEmailTextField.delegate = self
        userPasswordTextField.delegate = self
        let changePasswordSecureAction = UIAction { [weak self] _ in
            self?.changePasswordSecureAction()
        }
        changePasswordSecureButton.addAction(changePasswordSecureAction, for: .primaryActionTriggered)
        userPasswordTextField.rightView = changePasswordSecureButton
    }
    
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFOnboardingAuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userEmailTextField {
            userPasswordTextField.becomeFirstResponder()
            return true
        } else if textField == userPasswordTextField {
            textField.resignFirstResponder()
            return true
        }
        
        return true
    }
}

private extension FFOnboardingAuthenticationViewController {
    func setupConstraints(){
        authStackView.addArrangedSubview(userEmailTextField)
        authStackView.addArrangedSubview(userPasswordTextField)
        authStackView.addArrangedSubview(userConfirmPassword)
        authStackView.addArrangedSubview(savePasswordButton)
        authStackView.addArrangedSubview(readAccount)
        
        view.addSubview(loginUserLabel)
        loginUserLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        view.addSubview(authStackView)
        authStackView.snp.makeConstraints { make in
            make.top.equalTo(loginUserLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}

#Preview {
    let navVC = UINavigationController(rootViewController: FFOnboardingAuthenticationViewController())
    return navVC
}