//
//  ChatViewController.swift
//  Instagram Clone
//
//  Created by Lumbaram Choudhary on 14/07/22.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    // MARK: Variables
    var arrChatModel = [ChatModel]()
    var userId = String()
    var chatReference = Database.database().reference().child("Chats")
    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        getFirebaseChatData()
    }
    // MARK: sendMussageButtonClick
    @IBAction func sendMessageButton(_ sender: UIButton) {
        sendMessage()
        messageTextField.text = ""
        scrollToBottom()
    }
    // MARK: scrollToBottomAutomatically
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.arrChatModel.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    // MARK: getFirebaseChatData
    func getFirebaseChatData() {
        chatReference.observe(.value) { (snapshot) in
            guard let chatSnapshot = ChatSnapShot(snapshot: snapshot) else {
                self.arrChatModel = [ChatModel]()
                self.chatTableView.reloadData()
                return
            }
            print(chatSnapshot.chats)
            self.arrChatModel = chatSnapshot.chats
            self.arrChatModel.sort(by: {$0.chatId < $1.chatId})
            self.chatTableView.reloadData()
        }
    }
    func sendMessage() {
        let dict = ["username": userId,"message": messageTextField.text!] as [String : Any]
        chatReference.childByAutoId().setValue(dict)
    }
}
// MARK: TableView Delegate and DataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        cell.chatModel = arrChatModel[indexPath.row]
        
        if cell.chatModel?.username == userId {
            cell.messageLabel.isHidden = false
            cell.message2Label.isHidden = true
        } else {
            cell.messageLabel.isHidden = true
            cell.message2Label.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { action, view, completion in
            self.showEditAlert(index: indexPath.row)
        }
        edit.backgroundColor = .systemBlue
        let delete = UIContextualAction(style: .normal, title: "Delete") { action, view, completion in
            self.showDeleteAlert(index: indexPath.row)
        }
        delete.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [edit, delete])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    func showEditAlert(index: Int) {
        let chat = arrChatModel[index]
        let alert = UIAlertController(title: "Update Message", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text! = chat.message
        }
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            let id = chat.chatId
            let name = alert.textFields?.first?.text
            self.updatePost(postId: id, message: name!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    func updatePost(postId: String, message: String) {
        let dict = ["username": userId,"message": message] as [String : Any]
        chatReference.child(postId).setValue(dict)
    }
    func showDeleteAlert(index: Int) {
        let alert = UIAlertController(title: "Delete Message", message: "Are you sure", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.chatReference.child(self.arrChatModel[index].chatId).removeValue()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true)
    }
}

