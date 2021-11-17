//
//  SignInViewController.swift
//  FlashCardApp
//
//  Created by Nguyễn Đức Tân on 9/6/20.
//  Copyright © 2020 Nguyễn Đức Tân. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol SignInDelegate: AnyObject {
    func didSignIn()
}

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    weak var delegate: SignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functionView.layer.cornerRadius = 20
        signInButton.layer.cornerRadius = signInButton.frame.height/2
        navigationController?.setNavigationBarHidden(true, animated: false)
        setGesture()
        setupTextField()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
}

extension SignInViewController {
    
    func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        if checkEdited() {
            view.endEditing(true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkEditing() -> Bool {
        return emailTextField.isEditing || passwordTextField.isEditing
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: functionView) == true {
            return false
        }
        return true
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        guard checkEdited() else {
            return
        }
        guard let mail = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        view.endEditing(true)
        LoadingHud.show()
        AuthService.instance.login(email: mail, password: password) {[weak self] (success) in
            if success {
                self?.dismiss(animated: true) {
                    DataLocal.saveObject(3, forKey: AppKey.accountType)
                    self?.delegate?.didSignIn()
                }
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            let viewController = ForgotPasswordViewController()
            viewController.modalPresentationStyle = .overFullScreen
            viewController.modalTransitionStyle = .crossDissolve
            UIViewController.top()?.present(viewController, animated: true, completion: nil)
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func setupTextField() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func checkEdited() -> Bool {
        var check = true
        if emailTextField.text == "" {
            emailTextField.placeholder = Localizable.warningEmail
            check = false
        }
        if passwordTextField.text == "" {
            passwordTextField.placeholder = Localizable.warningPassword
            check = false
        }
        return check
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
