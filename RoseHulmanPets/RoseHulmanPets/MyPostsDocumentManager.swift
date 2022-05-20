//
//
//
//  Created by Maddie Sorensen on 3/31/22.
//

import Foundation
import Firebase
//TODO: import firebase

class MyPostsDocumentManager{
    static let shared = MyPostsDocumentManager()
    
    var _collectionRef: CollectionReference
    //var listenerRegistration: ListenerRegistration?
    
    private init(){
        _collectionRef=Firestore.firestore().collection(kPostsCollectionPath)
    }
    
    var latestPhotoBucket : Posts?
    var _latestDocument: DocumentSnapshot?
    var   groupDocumentId: String!
    var messageDocumentId: String!
    func startListening(for documentId: String){
        //TODO: recieve a changeListener
    }
    
    func startListening(for documentIdOne: String, changeListener: @escaping (()->Void))->ListenerRegistration{
        //TODO: recieve a changeListener
        print("one \(documentIdOne)")
//        print("two \(documentIdTwo)")
//        groupDocumentId=documentIdTwo
        messageDocumentId=documentIdOne
        let query=_collectionRef.document(documentIdOne)
        
        return query.addSnapshotListener { documentSnapshot, error in
            self._latestDocument=nil
            guard let document = documentSnapshot else{
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else{
                print("Document data was empty")
                return
            }
            print ("Current data : \(data)")
           
            self._latestDocument=document
            self.latestPhotoBucket = Posts(documentSnapshot: document)
            
            changeListener()
        }

        
    }
    
//
//    func startListening(for documentId: String, changeListener: @escaping (()->Void))->ListenerRegistration{
//        //TODO: recieve a changeListener
//        let query=_collectionRef.document(documentId)
//
//        return query.addSnapshotListener { documentSnapshot, error in
//            guard let document = documentSnapshot else{
//                print("Error fetching document: \(error!)")
//                return
//            }
//            guard let data = document.data() else{
//                print("Document data was empty")
//                return
//            }
//            print ("Current data : \(data)")
//            self.latestPhotoBucket = PhotoBucket(documentSnapshot: document)
//            changeListener()
//        }
//
//    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        //TODO: Implement
        listenerRegistration?.remove()
        
        
        
    }
    
    var caption: String{
        if let caption=_latestDocument?.get(kRosePetsQuote){
            return caption as! String
        }
        return ""
    }
    var photoUrl: String{
        if let photoUrl=_latestDocument?.get(kPhotoBucketUrl){
            return photoUrl as! String
        }
        return ""
    }
    
    var url: String{
        if let name=_latestDocument!.get(kPhotoBucketUrl){
            return name as! String
        }
        return ""
    }
    
    
    func updateUrl(photoDocId: String, imageUrl: String){
        _collectionRef.document(photoDocId).updateData([kRosePetsUrl : imageUrl]){
            err in
            if let err=err{
                print("Error updating document: \(err)")
            }else{
                print("document sucessfully updated")
            }
        }
        
    }
    
    func updateName(name: String, photoId: String){

        _collectionRef.document(photoId).updateData([kRosePetsQuote : name]){
            err in
            if let err=err{
                print("Error updating document: \(err)")
            }else{
                print("document sucessfully updated")
            }
        }

    }
    
    func updateCaption(caption: String, photoId: String){

        _collectionRef.document(photoId).updateData([kRosePetsQuote : caption]){
            err in
            if let err=err{
                print("Error updating document: \(err)")
            }else{
                print("document sucessfully updated")
            }
        }

    }
    func update(quote: String){
        
        print("groupDocumentId \(groupDocumentId)")
        print("messageDocumentId \(messageDocumentId)")
        _collectionRef.document(groupDocumentId).collection("Photos").document(messageDocumentId).updateData([kRosePetsQuote : quote]){
            err in
            if let err=err{
                print("Error updating document: \(err)")
            }else{
                print("document sucessfully updated")
            }
        }
        
    }
}
