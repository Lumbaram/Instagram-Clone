//
//  HomeViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit
import FirebaseStorage
import Firebase

class HomeViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var postTableView: UITableView!
    // MARK: Variables
    static let shared = HomeViewController()
    var arrPostData = [PostData]()
    var refreshController = UIRefreshControl()
    var postImage = UIImage()
    var snapNew = String()
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        getPostFirebaseData()
        refreshController.addTarget(self, action: #selector(pullToRefresh(refresh:)), for: .valueChanged)
        postTableView.refreshControl = refreshController
    }
    // MARK: pullToRefresh TableView
    @objc func pullToRefresh(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        postTableView.reloadData()
    }
    // MARK: AddImage for Post
    @IBAction func addImage(_ sender: Any) {
        let vc = PostViewController()
        vc.link = snapNew
        present(vc, animated: true)
    }
    // MARK: cameraButtonClick
    @IBAction func cameraButtonClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Error", message: "Camera is not working please check and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    // MARK: getPostFirebaseData
    func getPostFirebaseData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("Post").child(uid).observe(.value) { snapshot in
            self.arrPostData.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    self.snapNew = snap.key
                    if let mainDict = snap.value as? [String:AnyObject] {
                        let username = mainDict["username"] as? String
                        let message = mainDict["message"] as? String
                        let imageUrl = mainDict["imageUrl"] as? String
                        self.arrPostData.append(PostData(postId: snap.key, username: username!, message: message!, imageUrl: imageUrl ?? ""))
                        self.arrPostData.sort(by: {$0.postId > $1.postId})
                        print(mainDict)
                        self.postTableView.reloadData()
                    }
                }
                self.postTableView.reloadData()
            }
        }
    }
}
// MARK: TableView Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPostData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        cell.postData = arrPostData[indexPath.row]
        cell.userButton.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(likeButtonClick(sender:)), for: .touchUpInside)
        cell.postSaveButton.addTarget(self, action: #selector(postSaveButtonClick(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func tabButton() {
        print("Tab Button")
    }
    @objc func likeButtonClick(sender: UIButton) {
        sender.isSelected.toggle()
    }
    @objc func postSaveButtonClick(sender: UIButton) {
        sender.isSelected.toggle()
    }
}
