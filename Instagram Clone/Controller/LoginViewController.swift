//
//  LoginViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userLoginOrNot()
    }
    // MARK: loginButtonClick
    @IBAction func loginButtonClick(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if let error = error {
                self.showErrorAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.navigationToTabBarController()
            }
        }
    }
    // MARK: goToSignupPageButtonClick
    @IBAction func goToSignupPageButtonClick(_ sender: UIButton) {
        let navigation = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        navigationController?.pushViewController(navigation, animated: true)
    }
    // MARK: PasswordShowAndHideButtonClick
    @IBAction func PasswordShowAndHideButtonClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    // MARK: navigationToTabBarController
    func navigationToTabBarController() {
        let navigation = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        navigation.userId = emailTextField.text!
        navigationController?.pushViewController(navigation, animated: true)
    }
    // MARK: showErrorAlertForEmailAndPassword
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    // MARK: CheckUserLoginOrNot
    func userLoginOrNot() {
        if Auth.auth().currentUser != nil {
            navigationToTabBarController()
        }
    }
    
}
