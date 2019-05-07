import UIKit
import Firebase

class Post {
    
    var posts = [Post]()
    
    var caption: String!
    var imageDownloadURL: String?
    var image: UIImage!
    
    init() { }
    
//    init(document: DocumentSnapshot) {
//    }
    
    init(image: UIImage, caption: String){
        self.image = image
        self.caption = caption
    }
    
    func toDict() -> [String: Any] {
        return [
            "caption": caption,
            "imageDownloadURL": imageDownloadURL!
        ]
    }
    
}
