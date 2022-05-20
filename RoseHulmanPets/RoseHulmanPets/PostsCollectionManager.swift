//
//
//  Created by Maddie Sorensen on 3/31/22.
//

import Foundation

import Firebase

class PostsCollectionManager{
    
    static let shared = PostsCollectionManager()
    
    var _collectionRef: CollectionReference
    //var listenerRegistration: ListenerRegistration?
    
    private init(){
        _collectionRef=Firestore.firestore().collection(kPostsCollectionPath)
    }
    
    var latestPosts = [Posts]()
    
    
     var _latestDocument: DocumentSnapshot?
     var documentIdSent: String?
    
    
    func startListening(changeListener: @escaping (()->Void))->ListenerRegistration{
        //TODO: recieve a changeListener
        
       var  query=_collectionRef.order(by: kRosePetsLastTouched, descending: true).limit(to: 50)
//        if let authorFilter = authorFilter{
//            print ("TODO: filter by this author \(authorFilter)")
//            query = query.whereField(kMovieQuoteAuthorUid, isEqualTo: authorFilter)
//        }
        //let usersEmail=AuthManager.shared.currentUser?.email!
       // query=_collectionRef.whereField("memberEmails", arrayContains: AuthManager.shared.currentUser?.email!)
        return query.addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
            
            self.latestPosts.removeAll()
            for document in documents {
               print("\(document.documentID) => \(document.data())")
                self.latestPosts.append(Posts(documentSnapshot: document))
            }
            changeListener()
            }
        
    }
//      func startListening(for documentId: String, changeListener: @escaping (()->Void))->ListenerRegistration{
//          documentIdSent=documentId
//          var query=_collectionRef.order(by: kRosePetsLastTouched, descending: true).limit(to: 50)
////          var query=_collectionRef.document(documentId).collection("Photos").order(by: kPhotoBucketLastTouched, descending: true).limit(to: 50)
//              
//              //.order(by: kGroupChatCreated, descending: false).limit(to: 50)
//          
//
//          
//          return query.addSnapshotListener { querySnapshot, error in
//                  guard let documents = querySnapshot?.documents else {
//                      print("Error fetching documents: \(error!)")
//                      return
//                  }
//              
//              self.latestPosts.removeAll()
//              for document in documents {
//                  self.latestPosts.append(Posts(documentSnapshot: document))
//                  print(document.documentID)
//              }
//              changeListener()
//              }
//      }
//
//    var url: String{
//        if let name=_latestDocument!.get(kPhotoBucketUrl){
//            return name as! String
//        }
//        return ""
//    }
    
//    func startListening(filterByAuthor authorFilter: String?, changeListener: @escaping (()->Void))->ListenerRegistration{
//        //TODO: recieve a changeListener
//
//
//
//
//
//
//        var query=_collectionRef.order(by: kPhotoBucketLastTouched, descending: true).limit(to: 50)
//        if let authorFilter = authorFilter{
//            print ("TODO: filter by this author \(authorFilter)")
//            query = query.whereField(kPhotoBucketAuthorUid, isEqualTo: authorFilter)
//        }
//        return query.addSnapshotListener { querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//
//            self.latestPhotoBucket.removeAll()
//            for document in documents {
//            //    print("\(document.documentID) => \(document.data())")
//                self.latestPhotoBucket.append(PhotoBucket(documentSnapshot: document))
//            }
//            changeListener()
//            }
//
//}
    
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        //TODO: Implement
        listenerRegistration?.remove()
        
        
        
    }
    
    func add(groupId: String, mq: Posts, caption: String)->String{
        
        var ref: DocumentReference?=nil
        
        ref=_collectionRef.addDocument(data: [kRosePetsQuote: mq.quote, kRosePetsUrl: mq.url, kRosePetsLastTouched: Timestamp.init(),kRosePetsAuthorUid: AuthManager.shared.currentUser!.uid, kRosePetsAuthorEmail: AuthManager.shared.currentUser?.email]) { err in
            if let err=err{
                print("Error adding document \(err)")
            }else{
                print("document added with id \(ref!.documentID)")
            }
        }
        return ref!.documentID
    }
    
    func delete(photoId: String, groupId: String){
        _collectionRef.document(groupId).collection("Photos").document(photoId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
