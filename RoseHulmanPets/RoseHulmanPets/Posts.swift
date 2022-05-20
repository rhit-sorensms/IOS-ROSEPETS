
import Foundation
import Firebase

class Posts{
    var quote: String
    var url: String
    var documentId: String?
    var authorUid: String?
    var authorEmail: String?
    
    init(quote:String, url: String){
        self.quote=quote
        self.url=url
    }
    
    init(documentSnapshot: DocumentSnapshot){
        let data=documentSnapshot.data()
        self.quote = data?[kRosePetsQuote] as? String ?? ""
        self.url = data?[kPhotoBucketUrl] as? String ?? ""
        self.documentId = documentSnapshot.documentID
        self.authorUid = data?[kRosePetsAuthorUid] as? String ?? ""
        self.authorEmail = data?[kRosePetsAuthorEmail] as? String ?? ""
    }
}
