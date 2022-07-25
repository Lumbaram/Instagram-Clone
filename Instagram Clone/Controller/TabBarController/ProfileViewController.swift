// 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
//  ProfileViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit
import FirebaseAuth
import Firebase
import SDWebImage

class ProfileViewController: UIViewController, UITextViewDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var squareStackView: UIStackView!
    @IBOutlet var gridButtons: [UIButton]!
    @IBOutlet weak var postCollectionView: UICollectionView!
    // MARK: Variables
    var arrPostData = [PostData]()
    var cellSizeSet = CGFloat()
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfile.backgroundColor = .lightGray
        userProfile.layer.cornerRadius = userProfile.frame.width/2
        squareStackView.layer.borderWidth = 0.5
        squareStackView.layer.borderColor = UIColor.gray.cgColor
        postCollectionView.register(UINib(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionViewCellSizeChange(width: view.frame.width/3.2)
        getProfileAndUserNameData()
        getPostImages()
    }
    // MARK: editProfileButtonClick
    @IBAction func editProfileButtonClick(_ sender: UIButton) {
        let vc = EditProfileViewController()
        vc.userNameTextField.text = userName.text
        vc.bioTextField.text = bioLabel.text
        vc.editUserImage.image = userProfile.image
        present(vc, animated: true)
    }
    // MARK: gridButtonsClick
    @IBAction func gridButtonsClick(_ sender: UIButton) {
        gridButtons.forEach({$0.isSelected = false})
        sender.isSelected.toggle()
        if sender.tag == 1 {
            collectionViewCellSizeChange(width: view.frame.width/3.2)
        }else {
            collectionViewCellSizeChange(width: view.frame.width)
        }
    }
    // MARK: logOutButtonClick
    @IBAction func logOutButtonClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "LogOut", message: "Are you sure you want to LogOut", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
                let navi = self.storyboard?.instantiateViewController(withIdentifier: "navi")
                self.logOutButton.window?.rootViewController = navi
            } catch  {
                print("Error")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
    }
    // MARK: getProfileAndUserNameData
    func getProfileAndUserNameData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("Profile").child(uid).observe(.value) { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let mainDict = snap.value as? [String:AnyObject] {
                        let username = mainDict["username"] as? String
                        let bio = mainDict["bio"] as? String
                        let profileUrl = mainDict["profileUrl"] as? String
                        self.userName.text = username
                        self.bioLabel.text = bio
                        self.userProfile.sd_setImage(with: URL(string: profileUrl ?? ""))
                    }
                }
            }
        }
    }
    // MARK: getPostImages
    func getPostImages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("Post").child(uid).observe(.value) { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let mainDict = snap.value as? [String:AnyObject] {
                        let imageUrl = mainDict["imageUrl"] as? String
                        self.arrPostData.append(PostData(postId: snap.key, username: "", message: "", imageUrl: imageUrl ?? ""))
                        self.arrPostData.sort(by: {$0.postId > $1.postId})
                        print(mainDict)
                        self.postCollectionView.reloadData()
                    }
                }
                self.postCollectionView.reloadData()
            }
        }
    }
    // MARK: collectionViewCellSizeChange
    func collectionViewCellSizeChange(width: CGFloat) {
        cellSizeSet = width
        self.postCollectionView.reloadData()
    }
}
// MARK: CollectionView Delegate and DataSource Method
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPostData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCollectionViewCell
        cell.postImage.sd_setImage(with: URL(string: arrPostData[indexPath.row].imageUrl))
        self.postCountLabel.text = "\(arrPostData.count)"
        return cell
    }
}
// MARK: CollectionViewDelegateFlowLayout Method
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSizeSet, height: cellSizeSet)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
