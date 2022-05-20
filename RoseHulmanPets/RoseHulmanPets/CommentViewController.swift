
//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Maddie Sorensen on 4/21/22.
//

import UIKit
import Firebase
class CommentsTableViewCell: UITableViewCell{
    var buttonPressed : (() -> ()) = {}
    var deleteButtonPressed: (() -> ()) = {}
    @IBOutlet weak var authorImage: UIImageView!
    
    @IBAction func deleteButton(_ sender: Any) {
        deleteButtonPressed()
    }
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButton(_ sender: Any) {
        buttonPressed()
    }
}
class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var firstAuthorName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorImage: UIImageView!

    @IBOutlet weak var captionText: UILabel!
    
 
    var postListenerRegistration: ListenerRegistration?
    var commentListenerRegistration: ListenerRegistration?

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addCommentButton(_ sender: Any) {
        showAddCommentDialog()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    var photoDocumentId: String!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        
        postListenerRegistration = AllPostsDocumentManager.shared.startListening(for: photoDocumentId) {
            self.updateView()
        }
        commentListenerRegistration = CommentsCollectionManager.shared.startListening(for: photoDocumentId) {
            self.updateView()
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       AllPostsDocumentManager.shared.stopListening(postListenerRegistration)
        CommentsCollectionManager.shared.stopListening(commentListenerRegistration)
        super.viewDidDisappear(animated)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentsCollectionManager.shared.latestComments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
        let mq = CommentsCollectionManager.shared.latestComments[indexPath.row]
        cell.authorName.text=mq.authorName
        let  imgString = mq.authorPhoto!
        if let imgUrl = URL(string: imgString) {
            DispatchQueue.global().async { // Download in the background
                do {
                    let data = try Data(contentsOf: imgUrl)
                    DispatchQueue.main.async { // Then update on main thread
                        cell.authorImage.image = UIImage(data: data)
                        
                        cell.authorImage.layer.masksToBounds = true
                        cell.authorImage.layer.cornerRadius = cell.authorImage.bounds.width / 2
                        print("image is shown data: \(data)")
                    }
                } catch {
                    print("Error downloading image: \(error)")
                }
                
            }
        }
        cell.comment.text=mq.comment
        let aq = AllPostsDocumentManager.shared.latestPhotoBucket
        if(mq.authorEmail==AuthManager.shared.currentUser?.email){
            cell.editButton.isHidden=false
        }else{
            cell.editButton.isHidden=true
        }
        
        if(mq.authorEmail==AuthManager.shared.currentUser?.email || aq?.authorEmail==AuthManager.shared.currentUser?.email){
            cell.deleteButton.isHidden=false
        }else{
            cell.deleteButton.isHidden=true
        }
        cell.buttonPressed = {
            
            self.showEditCommentDialog(commentId: mq.documentId!, indexRow:indexPath.row)
        }
        cell.deleteButtonPressed={
            self.showDeleteCommentDialog(commentId: mq.documentId!, indexRow:indexPath.row)
        }
        return cell
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
        let mq = CommentsCollectionManager.shared.latestComments[indexPath.row]
        cell.authorName.text=mq.authorName
        
        let  imgString = mq.authorPhoto!
        if let imgUrl = URL(string: imgString) {
            DispatchQueue.global().async { // Download in the background
                do {
                    let data = try Data(contentsOf: imgUrl)
                    DispatchQueue.main.async { // Then update on main thread
                        cell.authorImage.image = UIImage(data: data)
                        print("image is shown data: \(data)")
                    }
                } catch {
                    print("Error downloading image: \(error)")
                }
                
            }
        }
        cell.comment.text=mq.comment

        return cell
    }
    
    
    
        @objc func showAddCommentDialog(){
    
            let alertController = UIAlertController(title: "Add a comment", message: "", preferredStyle: UIAlertController.Style.alert)
    
            alertController.addTextField { textField in
                textField.placeholder = "Comment"
            }
    
            let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
                print("you pressed cancel")
            }
    
            let createPhotoAction=UIAlertAction(title: "Post Comment", style: UIAlertAction.Style.default) { action in
                print("you pressed create quote")
                let quoteTextField=alertController.textFields![0] as UITextField
                let authorEmail=AuthManager.shared.currentUser?.email
                let docRef=Firestore.firestore().collection(kUsersCollectionPath).document(authorEmail!)
                var firstName=""
                var userPhoto=""
                 docRef.addSnapshotListener { documentSnapshot, error in
                       guard let document = documentSnapshot else {
                         print("Error fetching document: \(error!)")
                         return
                       }
                       guard let data = document.data() else {
                         print("Document data was empty.")
                         return
                       }
                       print("Current data: \(data)")
                     
                     firstName=document.get(kUserName) as! String
                     userPhoto=document.get(kUserPhotoUrl) as! String
                     AllPostsCollectionManager.shared.addComment(photoId: self.photoDocumentId,comment:quoteTextField.text!, authorName: firstName, authorPhoto: userPhoto)
                     }
     
            }
            alertController.addAction(createPhotoAction)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        }
    
    
    @objc func showEditCommentDialog(commentId: String, indexRow: Int){

        let alertController = UIAlertController(title: "Edit Comment", message: "", preferredStyle: UIAlertController.Style.alert)
        let mq = CommentsCollectionManager.shared.latestComments[indexRow]
        alertController.addTextField { textField in
            textField.placeholder = mq.comment
        }
        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("you pressed cancel")
        }
        let createPhotoAction=UIAlertAction(title: "Submit", style: UIAlertAction.Style.default) { action in
            print("you pressed create quote")
            let quoteTextField=alertController.textFields![0] as UITextField
            CommentsCollectionManager.shared.editComment(comment:quoteTextField.text!, commentId:commentId, photoId:self.photoDocumentId)
        
                 }

        alertController.addAction(createPhotoAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
        tableView.reloadData()
    }
    
    
    
    @objc func showDeleteCommentDialog(commentId: String, indexRow: Int){


        let alertController = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: UIAlertController.Style.alert)
        



        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("you pressed cancel")
        }

        let createPhotoAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { action in
            print("you pressed create quote")



            CommentsCollectionManager.shared.deleteComment(commentId:commentId, photoId:self.photoDocumentId)
        
                 }
     
        alertController.addAction(createPhotoAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
        tableView.reloadData()
    }
    
    func updateView(){
        let authorEmail=AllPostsDocumentManager.shared.latestPhotoBucket!.authorEmail
        let docRef=Firestore.firestore().collection(kUsersCollectionPath).document(authorEmail!)
         docRef.addSnapshotListener { documentSnapshot, error in
               guard let document = documentSnapshot else {
                 print("Error fetching document: \(error!)")
                 return
               }
               guard let data = document.data() else {
                 print("Document data was empty.")
                 return
               }
               print("Current data: \(data)")
             var firstName=""
             var userPhoto=""
             firstName=document.get(kUserName) as! String
             userPhoto=document.get(kUserPhotoUrl) as! String
             self.authorName.text=firstName
             self.firstAuthorName.text=firstName

             let  imgString = userPhoto
             if let imgUrl = URL(string: imgString) {
                 DispatchQueue.global().async { // Download in the background
                     do {
                         let data = try Data(contentsOf: imgUrl)
                         DispatchQueue.main.async { // Then update on main thread
                             self.authorImage.image = UIImage(data: data)
                             self.authorImage.layer.masksToBounds = true
                             self.authorImage.layer.cornerRadius = self.authorImage.bounds.width / 2
                             print("image is shown data: \(data)")
                         }
                     } catch {
                         print("Error downloading image: \(error)")
                     }
                 }
               }
             }

        self.captionText.text=AllPostsDocumentManager.shared.caption

        if  !AllPostsDocumentManager.shared.photoUrl.isEmpty{
            ImageUtils.load(imageView: postImage, from: AllPostsDocumentManager.shared.photoUrl)
            self.postImage.layer.cornerRadius = 10
            self.postImage.clipsToBounds = true

        }
    }

}

