//
//  SignupViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tabImage))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(gesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        title = "Sign up"
    }
    // MARK: tabImageForSelectAnyImage
    @objc func tabImage() {
        openImage()
    }
    // MARK: RegisterButtonClick
    @IBAction func registerButtonClick(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if let error = error {
                self.showErrorAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.navigationToTabBarController()
            }
        }
    }
    // MARK: goToLoginPageButtonClick
    @IBAction func goToLoginPageButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: PasswordShowAndHideButtonClick
    @IBAction func passwordShowAndHideButtonClick(_ sender: UIButton) {
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
        navigationController?.pushViewController(navigation, animated: true)
    }
    // MARK: showErrorAlertForEmailAndPassword
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
// MARK: ImagePickerControllerDelegate and NavigationControllerDelegate
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.editedImage] as? UIImage {
            userImage.image = image
            userImage.layer.cornerRadius = userImage.frame.width/2
        }
    }
}
