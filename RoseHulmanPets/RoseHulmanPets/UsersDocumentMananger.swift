//
//  UserDocumentManager.swift
//  Users
//
//  Created by Maddie Sorensen on 4/25/22.
//

import Foundation
import Firebase
//TODO: import firebase

class UsersDocumentManager{
    static let shared = UsersDocumentManager()
    
    var _collectionRef: CollectionReference
    //var listenerRegistration: ListenerRegistration?
    
    private init(){
        _collectionRef=Firestore.firestore().collection(kUsersCollectionPath)
    }
    
    //TODO: Implement create
   
    var _latestDocument: DocumentSnapshot?
    
    
    func addNewUserMaybe(uid: String, name: String?, photoUrl: String?){
        //get the user document for this uid
        //if it already exists do nothing
        // if there is no user document make it using the name and photoUrl
        let docuId=AuthManager.shared.currentUser?.email
        let docRef = _collectionRef.document(docuId!)
        
        
        docRef.getDocument { document, error in
            if let document = document, document.exists{
                print("Document exists.  Do nothing.  Here is hte data: \(document.data()!)")
            }else{
                print("Docuemnt does not exist.  Create this user!")
                docRef.setData([
                    kUserName: name ?? "",
                    kUserPhotoUrl: photoUrl ?? ""
                ]
                )
            }
        }
        
    }
    
    
    func startListening(for documentId: String, changeListener: @escaping (()->Void))->ListenerRegistration{
        //TODO: recieve a changeListener
        let query=_collectionRef.document(documentId)
        
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
            changeListener()
        }
        
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        //TODO: Implement
        listenerRegistration?.remove()
    }
    
    
    var name: String{
        if let name=_latestDocument?.get(kUserName){
            return name as! String
        }
        return ""
    }
    
    var photoUrl: String{
        if let photoUrl=_latestDocument?.get(kUserPhotoUrl){
            return photoUrl as! String
        }
        return ""
    }
    func updateName(name: String){

        _collectionRef.document(_latestDocument!.documentID).updateData([kUserName : name]){
            err in
            if let err=err{
                print("Error updating document: \(err)")
            }else{
                print("document sucessfully updated")
            }
        }

    }
    
    
    func updatePhotoUrl(photoUrl: String){

        _collectionRef.document(_latestDocument!.documentID).updateData([kUserPhotoUrl : photoUrl]){
            err in
            if let err=err{
                print("Error updating document: \(err)")
            }else{
                print("document sucessfully updated")
            }
        }

    }
}
