//
//  PostTableViewCell.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit
import Firebase
import SDWebImage

class PostTableViewCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var postImageCell: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postSaveButton: UIButton!
    @IBOutlet weak var postShareButton: UIButton!
    
    @IBOutlet weak var doubleTabLikeImage: UIImageView!
    // MARK: Variable
    var postData: PostData? {
        didSet {
            messageLabel.text = postData?.message
            postImageCell.sd_setImage(with: URL(string: postData!.imageUrl))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = userImage.frame.width/2
        getProfileFirebaseData()
        setUpDoubleTabImage()
    }
    func setUpDoubleTabImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        postImageCell.isUserInteractionEnabled = true
        postImageCell.addGestureRecognizer(tap)
    }
    @objc func doubleTapped() {
        likeButton.isSelected = true
        print("👍🏻like")
        showIcon()
    }
    func showIcon() {
        doubleTabLikeImage.isHidden = false
        self.doubleTabLikeImage.alpha = 1
        UIView.animate(withDuration: 1, delay: 0.5, options: UIView.AnimationOptions.transitionFlipFromTop) {
            self.doubleTabLikeImage.alpha = 0
        }
    }
    // MARK: getProfileFirebaseData
    func getProfileFirebaseData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("Profile").child(uid).observe(.value) { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let mainDict = snap.value as? [String:AnyObject] {
                        let username = mainDict["username"] as? String
                        let profileUrl = mainDict["profileUrl"] as? String
                        self.usernameLabel.text = username
                        self.userImage.sd_setImage(with: URL(string: profileUrl ?? ""))
                    }
                }
            }
        }
    }
    
}
