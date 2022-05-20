//
//  MyPageController.swift
//  RoseHulmanPets
//
//  Created by Maddie Sorensen on 5/16/22.
//



import UIKit

import Firebase

class PhotoCell: UICollectionViewCell{
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var authorName: UILabel!
    
    @IBOutlet weak var authorComment: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    
    
}

class MyPageController: UICollectionViewController {
    
    let kPhotoBucketCell="PhotoBucketCell"
    let kPhotoBucketDetailSegue = "PhotoBucketDetailSegue"
    var postsListenerRegistration: ListenerRegistration?
    
    var isShowingAllQuotes = true
    var logoutHandle: AuthStateDidChangeListenerHandle?
    
    var groupDocumentId: String!
    var captionText: String!
    var idToSend: String!
    var idForGroup: String!

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
        ///collectionView.reloadData()
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
            for mq in MyPostsCollectionManager.shared.latestPosts{
            self.collectionView.reloadData()
            }
        })
      
        
        
//        startListening(filterByAuthor: isShowingAllQuotes ? nil : AuthManager.shared.currentUser?.uid)
//        {
//                 self.tableView.reloadData()
//             }
    }
    
    
    func stopListeningForPosts(){
       MyPostsCollectionManager.shared.stopListening(postsListenerRegistration)
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
//    private let itemsPerRow: CGFloat = 3
//    private let sectionInsets = UIEdgeInsets(
//      top: 50.0,
//      left: 20.0,
//      bottom: 50.0,
//      right: 20.0)
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath){
        
        let mp=MyPostsCollectionManager.shared.latestPosts[indexPath.row]
        self.idToSend = mp.documentId!
        print(self.idToSend)
        self.performSegue(withIdentifier: kEditPhotoSegue, sender: self)
    }
    
    


        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return MyPostsCollectionManager.shared.latestPosts.count
        }

    
    override func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell

        let mq=MyPostsCollectionManager.shared.latestPosts[indexPath.row]
                
        
                let  imgString = mq.url
                if let imgUrl = URL(string: imgString) {
                    DispatchQueue.global().async { // Download in the background
                        do {
                            let data = try Data(contentsOf: imgUrl)
                            DispatchQueue.main.async { // Then update on main thread
                                cell.postImage.image = UIImage(data: data)
                                print("image is shown data: \(data)")
                                print("numPaths \(MyPostsCollectionManager.shared.latestPosts.count)")
                                
                            }
                        } catch {
                            print("Error downloading image: \(error)")
                        }
        
                    }
                    return cell
                }
      return cell
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kEditPhotoSegue{
            let mqdvc = segue.destination as! EditPhotoViewController
            print(idToSend)
            mqdvc.photoDocumentId = idToSend

        }

       
//        if segue.identifier == kLogoutSegue{
//
//        }
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
