//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Maddie Sorensen on 4/21/22.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController{
    
    
    var userListenerRegistration: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @IBOutlet weak var displayNameTextField: UITextField!
   
    
    @IBOutlet weak var profilePageImageView: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userListenerRegistration = UsersDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.email!) {
            self.updateView()
        }
       
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UsersDocumentManager.shared.stopListening(userListenerRegistration)
        super.viewDidDisappear(animated)
        
    }
    
    func updateView(){
        print("updating view")
        displayNameTextField.text=UsersDocumentManager.shared.name
        
        
        if  !UsersDocumentManager.shared.photoUrl.isEmpty{
            ImageUtils.load(imageView: profilePageImageView, from: UsersDocumentManager.shared.photoUrl)
            
        }
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        
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

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage?{
            //profilePageImageView.image=image
            StorageManager.shared.uploadProfilePhoto(uid: AuthManager.shared.currentUser!.uid, image: image)
        }
        picker.dismiss(animated: true)
    }
}
