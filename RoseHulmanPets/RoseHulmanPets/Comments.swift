
import Foundation
import Firebase

class Comments{
    var comment: String
    var authorPhoto: String?
    var documentId: String?
    //var authorUid: String?
    var authorEmail: String?
    var authorName: String?
    
    init(comment:String){
        self.comment=comment
        
    }
    
    init(documentSnapshot: DocumentSnapshot){
        let data=documentSnapshot.data()
        self.comment = data?[kComment] as? String ?? ""
        self.authorPhoto = data?[kCommentAuthorPhoto] as? String ?? ""
        self.documentId = documentSnapshot.documentID
       // self.authorUid = data?[kRosePetsAuthorUid] as? String ?? ""
        self.authorEmail = data?[kCommentAuthorEmail] as? String ?? ""
        self.authorName = data?[kCommentAuthorName] as? String ?? ""
    }
}
