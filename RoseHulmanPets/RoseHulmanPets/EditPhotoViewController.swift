//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Maddie Sorensen on 4/21/22.
//

import UIKit
import Firebase

class EditPhotoViewController: UIViewController{
    
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionText: UITextField!
    var postListenerRegistration: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var photoDocumentId: String!
    @IBAction func deleteButton(_ sender: Any) {
        
        self.showDeletePhotoDialog()
        
    }
    
    
    
    @IBAction func displayCaptionChanged(_ sender: Any) {
        MyPostsDocumentManager.shared.updateName(name: captionText.text!, photoId: photoDocumentId)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postListenerRegistration = MyPostsDocumentManager.shared.startListening(for: photoDocumentId) {
            self.updateView()
        }
       
        
    }
    @objc func showDeletePhotoDialog(){


        let alertController = UIAlertController(title: "Delete Photo", message: "Are you sure you want to delete this photo?", preferredStyle: UIAlertController.Style.alert)
        



        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { action in
            print("you pressed cancel")
        }

        let createPhotoAction=UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { action in
            print("you pressed create quote")



            MyPostsCollectionManager.shared.deletePhoto(photoId:self.photoDocumentId)
            self.navigationController?.popViewController(animated: true)
                 }
     
        alertController.addAction(createPhotoAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
       MyPostsDocumentManager.shared.stopListening(postListenerRegistration)
        super.viewDidDisappear(animated)
        
    }
    
    func updateView(){
        print("updating view")
        //displayNameTextField.text=UsersDocumentManager.shared.name
        captionText.text=MyPostsDocumentManager.shared.caption
        
        let docRef=Firestore.firestore().collection(kUsersCollectionPath).document((AuthManager.shared.currentUser?.email!)!)
         
         
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
             self.authorName.text=firstName
             
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
                             
                             //imageView.image=UIImage(image:data)
                             
                             
                         }
                     } catch {
                         print("Error downloading image: \(error)")
                     }
                     
                 }
             }
             //cell.authorImage.image=userPhoto
             }
        
        
        
        
        if  !MyPostsDocumentManager.shared.photoUrl.isEmpty{
            ImageUtils.load(imageView: postImage, from: MyPostsDocumentManager.shared.photoUrl)
            self.postImage.layer.cornerRadius = 10
            self.postImage.clipsToBounds = true
            
        }
    }
    
    @IBAction func pressedChangePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            imagePicker.sourceType = .camera}
        else{
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
    //    @IBAction func displayNameDidChange(_ sender: Any) {
//        print("TODO: Update name to \(displayNameTextField.text)")
//
//        MyPostsDocumentManager.shared.updateName(name: displayNameTextField.text!, photoId: photoDocumentId)
//    }
    
//    @IBAction func pressedChangedProfilePhoto(_ sender: Any) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate=self
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
//            imagePicker.sourceType = .camera}
//        else{
//            imagePicker.sourceType = .photoLibrary
//        }
//
//        present(imagePicker, animated: true)
//
//    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?{
            //profilePageImageView.image=image
            StorageManager.shared.updatePhoto(image: image, photoId: photoDocumentId)
        }
        picker.dismiss(animated: true)
    }
}
