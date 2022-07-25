//
//  EditProfileViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 19/07/22.
//

import UIKit
import FirebaseStorage
import Firebase

class EditProfileViewController: UIViewController {
    // MARK: Variables
    var editUserImage = UIImageView()
    var saveButton = UIButton()
    var userNameTextField = UITextField()
    var cancelButton = UIButton()
    var bioTextField = UITextField()
    var selectPhotoLabel = UILabel()
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUserImage()
        setupSaveButton()
        setUpUserNameText()
        setupCancelButton()
        setUpBioTextField()
        setupSelectPhotoLabel()
        view.backgroundColor = .tertiarySystemBackground
    }
    func setupUserImage() {
        editUserImage.frame = CGRect(x: view.frame.width/2-75, y: 48, width: 150, height: 150)
        editUserImage.backgroundColor = .gray
        editUserImage.layer.cornerRadius = editUserImage.frame.width/2
        editUserImage.layer.masksToBounds = true
        view.addSubview(editUserImage)
        editUserImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        editUserImage.addGestureRecognizer(gesture)
    }
    @objc func tapImage() {
        openImage()
    }
    func setupSelectPhotoLabel() {
        selectPhotoLabel.frame = CGRect(x: view.frame.width/2-75, y: 98, width: 150, height: 50)
        selectPhotoLabel.text = "Select Photo"
        selectPhotoLabel.font = .systemFont(ofSize: 26)
        view.addSubview(selectPhotoLabel)
    }
    func setupCancelButton() {
        cancelButton.frame = CGRect(x: 16, y: 8, width: 80, height: 30)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.link, for: .normal)
        view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
    }
    @objc func cancelButtonClick() {
        dismiss(animated: true)
    }
    func setUpUserNameText() {
        userNameTextField.frame = CGRect(x: 40, y: 250, width: view.frame.width-80, height: 50)
        userNameTextField.placeholder = "Please Enter UserName"
        userNameTextField.textAlignment = .center
        userNameTextField.layer.borderWidth = 1
        userNameTextField.layer.cornerRadius = 20
        userNameTextField.layer.masksToBounds = true
        view.addSubview(userNameTextField)
    }
    func setUpBioTextField() {
        bioTextField.frame = CGRect(x: 40, y: 320, width: view.frame.width-80, height: 50)
        bioTextField.placeholder = "Please Enter Bio"
        bioTextField.textAlignment = .center
        bioTextField.layer.borderWidth = 1
        bioTextField.layer.cornerRadius = 20
        bioTextField.layer.masksToBounds = true
        view.addSubview(bioTextField)
    }
    func setupSaveButton() {
        saveButton.frame = CGRect(x: view.frame.width/2-100, y: 400, width: 200, height: 50)
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .link
        saveButton.setTitle("Save", for: .normal)
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
    }
    @objc func saveButtonClick() {
        setProfileFirebaseData()
        dismiss(animated: true)
    }
}
// MARK: ImagePickerControllerDelegate and NavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        editUserImage.image = image
    }
    func setProfileFirebaseData() {
        guard let uid = Auth.auth().currentUser?.email else { return }
        let storage = Storage.storage().reference().child(uid)
        guard let imageData = editUserImage.image?.pngData() else { return }
        storage.child("profile/path.png").putData(imageData) { _, error in
            guard error == nil else { return }
        }
        storage.child("profile/path.png").downloadURL { url, error in
            guard let url = url, error == nil else { return }
            let urlString = url.absoluteString
            print(urlString)
            let dict = ["username": self.userNameTextField.text!,"bio": self.bioTextField.text!,"profileUrl": urlString] as [String : Any]
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("Profile").child(uid).childByAutoId().setValue(dict)
        }
    }
}
