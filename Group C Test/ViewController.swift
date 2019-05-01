import UIKit
import MobileCoreServices
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var captionText: UITextField!
    var post = Post()
    
    @IBAction func uploadButton(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let image = UIImage(named: "demo")!
        save(post)
    }
    
    
    func save(_ post: Post) {
        upload(post.image) { storageMeta, error in
            
            let ref = Firestore.firestore().collection("posts").document()
            post.imageDownloadURL = storageMeta?.name
            ref.setData(post.toDict()) { err in
                
            }
        }
    }

    func upload(_ image: UIImage, completion: @escaping (StorageMetadata?, Error?) -> Void) {

        let uuid = UUID().uuidString
        //1. Create new database reference
        //let newPostRef = Database.database().reference().child("photoPost").childByAutoId()
        //let newPostKey = newPostRef.key
        //2. Create a new storage reference
        let imageStorageRef = Storage.storage().reference().child(uuid)
        let data = image.jpegData(compressionQuality: 0.7)!
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        //3. Save image to storage first
        imageStorageRef.putData(data, metadata: meta) { storageMeta, error in
            completion(storageMeta, error)
        }
        
        //4. Save the post caption & download URL
        
    }
    
    
}



//extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[.originalImage] as! UIImage
//        self.imagePreview.image = self.upload(image)
//        upload(image)
//        dismiss(animated:true, completion: nil)
//    }
//}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        post.image = image
        post.caption = Date().description
        dismiss(animated:true, completion: nil)
    }
}
