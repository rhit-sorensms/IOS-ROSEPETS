//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Maddie Sorensen on 4/21/22.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController{
    var logoutHandle: AuthStateDidChangeListenerHandle?
    
    var postsListenerRegistration: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    var photoDocId: String!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    
   
    @IBOutlet weak var captionText: UITextField!
    
    @IBAction func postButton(_ sender: Any) {
        MyPostsDocumentManager.shared.updateCaption(caption: captionText.text!, photoId: photoDocId)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func captionDidChange(_ sender: Any) {
       //MyPostsDocumentManager.shared.updateCaption(caption: captionText.text!, photoId: photoDocId)
    }
    @IBAction func uploadPhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagePicker.sourceType = .camera}
        else{
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForPosts()
        AuthManager.shared.removeObserver(logoutHandle)
    }
    
    
    
    func startListeningForPosts(){
        stopListeningForPosts()
        postsListenerRegistration = MyPostsCollectionManager.shared.startListening( changeListener: {
            //self.reloadData()
        })
      
        
        
//        startListening(filterByAuthor: isShowingAllQuotes ? nil : AuthManager.shared.currentUser?.uid)
//        {
//                 self.tableView.reloadData()
//             }
    }
    
    
    func stopListeningForPosts(){
       MyPostsCollectionManager.shared.stopListening(postsListenerRegistration)
    }
    
   
    
    
    func updateView(){
        print("updating view")
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
             var userPhotos=""
             firstName=document.get(kUserName) as! String
             userPhotos=document.get(kUserPhotoUrl) as! String
             //lastName=document.get(kLastName) as! String
             self.userName.text=firstName
             let  imgString = userPhotos
             if let imgUrl = URL(string: imgString) {
                 DispatchQueue.global().async { // Download in the background
                     do {
                         let data = try Data(contentsOf: imgUrl)
                         DispatchQueue.main.async { // Then update on main thread
                             self.userPhoto.image = UIImage(data: data)
                             self.userPhoto.layer.masksToBounds = true
                             self.userPhoto.layer.cornerRadius = self.userPhoto.bounds.width / 2
                             print("image is shown data: \(data)")
                             
                             //imageView.image=UIImage(image:data)
                             
                             
                         }
                     } catch {
                         print("Error downloading image: \(error)")
                     }
                     
                 }
         }
        
       
         }
//
        if  !UsersDocumentManager.shared.photoUrl.isEmpty{
            ImageUtils.load(imageView: userPhoto, from: UsersDocumentManager.shared.photoUrl)
            
        }
        if  !MyPostsDocumentManager.shared.photoUrl.isEmpty{
            ImageUtils.load(imageView: postImage, from: MyPostsDocumentManager.shared.photoUrl)
            
        }
    }
    
    @IBAction func displayNameDidChange(_ sender: Any) {
        print("TODO: Update name to \(displayNameTextField.text)")
        
        UsersDocumentManager.shared.updateName(name: displayNameTextField.text!)
    }
    
    @IBAction func pressedChangedProfilePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagePicker.sourceType = .camera}
        else{
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
        
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?{
            //profilePageImageView.image=image
             var docId=StorageManager.shared.uploadPhoto(caption: captionText.text!, image: image, uid:AuthManager.shared.currentUser!.uid)
            photoDocId=docId
            let docRef=Firestore.firestore().collection(kPostsCollectionPath).document(docId)
             
             
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
                
                 var userPhotos=""
               
                 userPhotos=document.get(kRosePetsUrl) as! String
                 let  imgString = userPhotos
                 if let imgUrl = URL(string: imgString) {
                     DispatchQueue.global().async { // Download in the background
                         do {
                             let data = try Data(contentsOf: imgUrl)
                             DispatchQueue.main.async { [self] in // Then update on main thread
                                 self.postImage.image = UIImage(data: data)
                                 self.postImage.layer.cornerRadius = 10
                                 self.postImage.clipsToBounds = true
                                 print("image is shown data: \(data)")
                                 
                                 //imageView.image=UIImage(image:data)
                                 
                                 
                             }
                         } catch {
                             print("Error downloading image: \(error)")
                         }
                         
                     }
                 }
             }
        }
        picker.dismiss(animated: true)
    }
}
