//
//  StorageManager.swift
//  PhotoBucket
//
//  Created by Maddie Sorensen on 4/26/22.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class StorageManager{
    static let shared = StorageManager()
    
    var _storageRef: StorageReference
    //var listenerRegistration: ListenerRegistration?
    
    private init(){
        _storageRef=Storage.storage().reference()
    }
    
    //TODO: Implement create
   
    func uploadProfilePhoto(uid: String, image: UIImage){
        guard let imageData = ImageUtils.resize(image: image) else {
            print("converting the image to data fails!")
            return
        }
        
        let photoRef = _storageRef.child(kUsersCollectionPath).child(uid)
        photoRef.putData(imageData)
        
        photoRef.putData(imageData, metadata: nil) { metadata, error in
            if let error=error{
                print("there was an error uploading the image \(error)")
                return
            }
            print("Upload complete. TODO: Get the download url")
            photoRef.downloadURL { downloadUrl, erorr in
                if let erorr = erorr {
                    print("There was an error downloading image")
                    return
                }
                UsersDocumentManager.shared.updatePhotoUrl(photoUrl: downloadUrl?.absoluteString ?? "")
            }
        }
    }
    
    
    func uploadPhoto(caption: String, image: UIImage, uid: String)->String{
        guard let imageData = ImageUtils.resize(image: image) else {
            print("converting the image to data fails!")
            return "0"
        }
        let mq = Posts(quote: caption, url: "")
        // Use the PhotoDocumentManager to upload the caption.  Return from that funciton the document ID
        let docId = MyPostsCollectionManager.shared.add(mq:mq, caption:caption)
        
        
        // use the docId to upload (putData) into Stroage
            // Once done get the downloadUrl
                // THEN put the download URL onto the photo
               // PhotoBucketDocumentManager.shared.update(groupId: groupId, photoDocId: docId, imageUrl: )
            
        
        
        
        let photoRef = _storageRef.child("Photos").child(docId)
        
        photoRef.putData(imageData, metadata: nil) { metadata, error in
            if let error=error{
                print("there was an error uploading the image \(error)")
                return
            }
            print("Upload complete. TODO: Get the download url")
            photoRef.downloadURL { downloadUrl, erorr in
                if let erorr = erorr {
                    print("There was an error downloading image \(error!)")
                    return
                }
                
//                let mq = PhotoBucket(quote: caption, url: downloadUrl?.absoluteString ?? "")
                
                MyPostsDocumentManager.shared.updateUrl(photoDocId: docId, imageUrl: downloadUrl?.absoluteString ?? "")
                //PhotoBucketCollectionManager.shared.add(mq)
                //PhotoBucket.init(quote: "", url: downloadUrl?.absoluteString ?? "")
                //UsersDocumentManager.shared.updatePhotoUrl(photoUrl: downloadUrl?.absoluteString ?? "")
            }
        }
        return docId
    }
    
    
    
    func updatePhoto(image: UIImage, photoId: String){
        guard let imageData = ImageUtils.resize(image: image) else {
            print("converting the image to data fails!")
            return
        }
        //let mq = Posts(quote: caption, url: "")
        // Use the PhotoDocumentManager to upload the caption.  Return from that funciton the document ID
        //let docId = MyPostsCollectionManager.shared.add(mq:mq, caption:caption)
        
        
        // use the docId to upload (putData) into Stroage
            // Once done get the downloadUrl
                // THEN put the download URL onto the photo
               // PhotoBucketDocumentManager.shared.update(groupId: groupId, photoDocId: docId, imageUrl: )
            
        
        
        
        let photoRef = _storageRef.child("Photos").child(photoId)
        
        photoRef.putData(imageData, metadata: nil) { metadata, error in
            if let error=error{
                print("there was an error uploading the image \(error)")
                return
            }
            print("Upload complete. TODO: Get the download url")
            photoRef.downloadURL { downloadUrl, erorr in
                if let erorr = erorr {
                    print("There was an error downloading image \(error!)")
                    return
                }
                
//                let mq = PhotoBucket(quote: caption, url: downloadUrl?.absoluteString ?? "")
                
                MyPostsDocumentManager.shared.updateUrl(photoDocId: photoId, imageUrl: downloadUrl?.absoluteString ?? "")
                //PhotoBucketCollectionManager.shared.add(mq)
                //PhotoBucket.init(quote: "", url: downloadUrl?.absoluteString ?? "")
                //UsersDocumentManager.shared.updatePhotoUrl(photoUrl: downloadUrl?.absoluteString ?? "")
            }
        }
    }
}
