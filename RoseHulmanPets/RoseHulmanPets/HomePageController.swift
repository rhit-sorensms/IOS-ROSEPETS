

import UIKit

import Firebase

class PostsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var secondAuthorName: UILabel!
    @IBOutlet weak var authorComment: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    
    @IBOutlet weak var postImage: UIImageView!
}

class HomePageController: UITableViewController {
    
    let kPhotoBucketCell="PhotoBucketCell"
    let kPhotoBucketDetailSegue = "PhotoBucketDetailSegue"
    var postsListenerRegistration: ListenerRegistration?
    
    var isShowingAllQuotes = true
    var logoutHandle: AuthStateDidChangeListenerHandle?
    
    var groupDocumentId: String!
    var captionText: String!
    var idToSend: String!
    var idForGroup: String!
    @IBOutlet weak var signedInImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //navigationItem.leftBarButtonItem = self.editButtonItem
//        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showAddQuoteDialog))
        
//        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showAddQuoteDialog))
        
//
        //self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "☰",
//                                                               style: UIBarButtonItem.Style.plain,
//                                                               target: self,
//                                                               action: #selector(showMenu))
         }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    startListeningForPosts()
       
//       photoBucketListenerRegistration = PhotoBucketCollectionManager.shared.startListening{
//            print("The photos were updated")
//            for mq in PhotoBucketCollectionManager.shared.latestPhotoBucket{
//               // print ("\(mq.quote) in \(mq.movie)")
//                self.tableView.reloadData()
//            }
//
//        }
        
        logoutHandle=AuthManager.shared.addLogoutObserver(callback: {
            print("someone signed out")
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    func update(){
        var email=AuthManager.shared.currentUser?.email!
        let docRef=Firestore.firestore().collection(kUsersCollectionPath).document(email!)
         
         
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
             var lastName=""
             var userPhoto=""
             firstName=document.get(kUserName) as! String
             userPhoto=document.get(kUserPhotoUrl) as! String
             //lastName=document.get(kLastName) as! String
//             cell.authorName.text=firstName
//             cell.secondAuthorName.text=firstName
             
             let  imgString = userPhoto
             if let imgUrl = URL(string: imgString) {
                 DispatchQueue.global().async { // Download in the background
                     do {
                         let data = try Data(contentsOf: imgUrl)
                         DispatchQueue.main.async { // Then update on main thread
                             let imageUsed = UIImage(data: data)
                             let button = UIButton.init(type: .custom)
                                 //set image for button
                             button.setImage(imageUsed, for: UIControl.State.normal)
                                 //add function for button
//                                 button.addTarget(self, action: #selector(ViewController.fbButtonPressed), for: UIControlEvents.touchUpInside)
                                 //set frame
                                 button.frame = CGRect(x: 30, y: 30, width: 5, height: 5)
                        
                             let barButton = UIBarButtonItem(customView: button)
                                 //assign button to navigationbar
                                 self.navigationItem.rightBarButtonItem = barButton
                             
//                             self.navigationItem.rightBarButtonItem!.frame = CGRect(x: 10, y: 100, width: 10, height: 10)
//                             self.navigationItem.rightBarButtonItem!.setBackgroundImage(imageUsed, for: UIControl.State.normal, barMetrics: UIBarMetrics.default)
//                             cell.authorImage.layer.masksToBounds = true
//                             cell.authorImage.layer.cornerRadius = cell.authorImage.bounds.width / 2
//                             print("image is shown data: \(data)")
                             

                         }
                     } catch {
                         print("Error downloading image: \(error)")
                     }
                     
                 }
             }
             //cell.authorImage.image=userPhoto
             }

        
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForPosts()
        AuthManager.shared.removeObserver(logoutHandle)
    }
    
    
    
    func startListeningForPosts(){
        stopListeningForPosts()
        postsListenerRegistration = PostsCollectionManager.shared.startListening( changeListener: {
            self.tableView.reloadData()
        })
      
        
        
//        startListening(filterByAuthor: isShowingAllQuotes ? nil : AuthManager.shared.currentUser?.uid)
//        {
//                 self.tableView.reloadData()
//             }
    }
    
    
    func stopListeningForPosts(){
       PostsCollectionManager.shared.stopListening(postsListenerRegistration)
    }
    @objc func showMenu(){
        print()
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: UIAlertController.Style.actionSheet)
        let showOnlyMyQuotesAction = UIAlertAction(title: isShowingAllQuotes ? "Show only my qotes": "Show all quotes", style: UIAlertAction.Style.default) { action in
            print("You pressed show only my quotes")
            self.isShowingAllQuotes = !self.isShowingAllQuotes
            self.startListeningForPosts()
            
        }
        
        alertController.addAction(showOnlyMyQuotesAction)
        
        let showAddQuoteDialogAction = UIAlertAction(title: "Add a quote", style: UIAlertAction.Style.default) { action in
            print("You pressed show only my quotes")
            //self.showAddQuoteDialog()
        }
        
        alertController.addAction(showAddQuoteDialogAction)
        
        let signOutAction = UIAlertAction(title: "Signout", style: UIAlertAction.Style.default) { action in
            print("You pressed show only my quotes")
            AuthManager.shared.signOut()
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("you pressed cancel")}
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
            
        }
    
//    @objc func showAddQuoteDialog(){
//
//
//        let alertController = UIAlertController(title: "Create a new photo", message: "", preferredStyle: UIAlertController.Style.alert)
//
//        alertController.addTextField { textField in
//            textField.placeholder = "Text"
//        }
//
//
////        alertController.addTextField { textField in
////            textField.placeholder = "Photo URL"
////        }
//
//        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
//            print("you pressed cancel")
//        }
//
//        let createPhotoAction=UIAlertAction(title: "Select Photo", style: UIAlertAction.Style.default) { action in
//            print("you pressed create quote")
//
//
//            let quoteTextField=alertController.textFields![0] as UITextField
//           // let urlTextField=alertController.textFields![1] as UITextField
//
//            print("Quote: \(quoteTextField.text!)")
//            //print("URL: \(urlTextField.text!)")
//
//            self.captionText=quoteTextField.text
//            //let mq = Posts(quote: quoteTextField.text!, url: urlTextField.text!)
////
//
//            //TODO: figure out what to do to add data
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate=self
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
//                imagePicker.sourceType = .camera}
//            else{
//                imagePicker.sourceType = .photoLibrary
//            }
//
//            self.present(imagePicker, animated: true)
//            //PhotoBucketCollectionManager.shared.add(mq)
//        }
//
//        alertController.addAction(createPhotoAction)
//        alertController.addAction(cancelAction)
//        present(alertController,animated: true)
//    }

    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mp=PostsCollectionManager.shared.latestPosts[indexPath.row]
//        self.idToSend = mp.documentId!
//        self.idForGroup=groupDocumentId
//        print(self.idToSend)
//        self.performSegue(withIdentifier: kPhotoBucketDetailSegue, sender: self)
//
//
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mp=PostsCollectionManager.shared.latestPosts[indexPath.row]
        self.idToSend = mp.documentId!
        //self.idForGroup=groupDocumentId
        print(self.idToSend)
        self.performSegue(withIdentifier: kCommentsSegue, sender: self)
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // return movieQuotes.count'
        //PostsCollectionManager.shared.latestPosts.count
        return PostsCollectionManager.shared.latestPosts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(400)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! PostsTableViewCell
        
  
        let mq=PostsCollectionManager.shared.latestPosts[indexPath.row]
        //cell.quoteLabel.text = mq.quote
        cell.authorName.text=mq.authorEmail
        cell.authorComment.text=mq.quote
        
        let  imgString = mq.url
        if let imgUrl = URL(string: imgString) {
            DispatchQueue.global().async { // Download in the background
                do {
                    let data = try Data(contentsOf: imgUrl)
                    DispatchQueue.main.async { // Then update on main thread
                        cell.postImage.image = UIImage(data: data)
                        cell.postImage.layer.cornerRadius = 10
                        cell.postImage.clipsToBounds = true
                        //cell.postImage.layer.borderWidth = 3
                        print("image is shown data: \(data)")
                        
                        //imageView.image=UIImage(image:data)
                        
                        
                    }
                } catch {
                    print("Error downloading image: \(error)")
                }
                
            }
        }
        
        let docRef=Firestore.firestore().collection(kUsersCollectionPath).document(mq.authorEmail!)
         
         
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
             var lastName=""
             var userPhoto=""
             firstName=document.get(kUserName) as! String
             userPhoto=document.get(kUserPhotoUrl) as! String
             //lastName=document.get(kLastName) as! String
             cell.authorName.text=firstName
             cell.secondAuthorName.text=firstName
             
             let  imgString = userPhoto
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
             //cell.authorImage.image=userPhoto
             }
        //cell.postImage=mq.url
        
        


        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let mq=PostsCollectionManager.shared.latestPosts[indexPath.row]
        //let hq=GroupsManager.shared.owner
        return AuthManager.shared.currentUser?.uid == mq.authorUid
    }
   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            //TODO: implement delete
            
            let mqToDelete=PostsCollectionManager.shared.latestPosts[indexPath.row]
            PostsCollectionManager.shared.delete(photoId: mqToDelete.documentId!,groupId: groupDocumentId)
            
            
        }
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kCommentsSegue{
            let mqdvc = segue.destination as! CommentViewController
            if let indexPath = tableView.indexPathForSelectedRow{


                let mq=PostsCollectionManager.shared.latestPosts[indexPath.row]
                //mqdvc.photoBucketDocumentId = mq.documentId
                mqdvc.photoDocumentId = idToSend!
           // mqdvc.groupDocumentId=idForGroup

            }
        }
//
   }
    

}

//extension HomePageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?{
//            //profilePageImageView.image=image
//            StorageManager.shared.uploadPhoto(caption: captionText, image: image, groupId:groupDocumentId, uid: AuthManager.shared.currentUser!.uid)
//        }
//        picker.dismiss(animated: true)
//    }
//}
