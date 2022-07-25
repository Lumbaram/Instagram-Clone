//
//  PostViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Firebase

class PostViewController: UIViewController, UITextViewDelegate {
    // MARK: Variables
    var postImage = UIImageView()
    var button = UIButton()
    var cancelButton = UIButton()
    var postTextView = UITextView()
    var placeholderLabel = UILabel()
    var link = String()
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPostImage()
        setupButton()
        setupCancelButton()
        setupPostTextView()
        setupPlaceholder()
        postTextView.delegate = self
        placeholderLabel.isHidden = !postTextView.text.isEmpty
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func setupPostImage() {
        postImage.frame = CGRect(x: 30, y: 50, width: view.frame.width-60, height: 250)
        postImage.backgroundColor = .gray
        postImage.image = UIImage(named: "img")
        view.addSubview(postImage)
        postImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        postImage.addGestureRecognizer(gesture)
    }
    @objc func tapImage() {
        openImage()
    }
    func setupPlaceholder() {
        placeholderLabel.frame = CGRect(x: 36, y: 328, width: view.frame.width-60, height: 20)
        placeholderLabel.text = "Share new post..."
        placeholderLabel.textColor = .gray
        placeholderLabel.font = .systemFont(ofSize: 18)
        view.addSubview(placeholderLabel)
    }
    func setupPostTextView() {
        postTextView.frame = CGRect(x: 30, y: 320, width: view.frame.width-60, height: 80)
        postTextView.layer.borderWidth = 2
        postTextView.font = .systemFont(ofSize: 18)
        view.addSubview(postTextView)
    }
    func setupButton() {
        button.frame = CGRect(x: 75, y: 420, width: view.frame.width-150, height: 50)
        button.backgroundColor = .link
        button.setTitle("Post", for: .normal)
        button.layer.cornerRadius = 20
        view.addSubview(button)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    @objc func tapButton() {
        if postImage.image == UIImage(named: "img") {
            showImageAlert(title: "Error", message: "Please select Image")
        } else {
            setPostFirebaseData()
            dismiss(animated: true)
        }
    }
    func setupCancelButton() {
        cancelButton.frame = CGRect(x: 16, y: 8, width: 80, height: 30)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.link, for: .normal)
        view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    // MARK: showImageAlert
    func showImageAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
// MARK: ImagePickerControllerDelegate and NavigationControllerDelegate
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        postImage.image = image
    }
    func setPostFirebaseData() {
        guard let uid = Auth.auth().currentUser?.email else { return }
        let storage = Storage.storage().reference().child(uid)
        guard let imageData = postImage.image?.pngData() else { return }
        storage.child("images\(uid)/path\(link).png").putData(imageData) { _, error in
            guard error == nil else { return }
        }
        storage.child("images\(uid)/path\(link).png").downloadURL { url, error in
            guard let url = url, error == nil else { return }
            let urlString = url.absoluteString
            print(urlString)
            let dict = ["username": (Auth.auth().currentUser?.email)!,"message": self.postTextView.text!,"imageUrl": urlString] as [String : Any]
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("Post").child(uid).childByAutoId().setValue(dict)
        }
    }
}
