import UIKit
import MobileCoreServices
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var captionText: UITextField!
    var post = Post()
    
    @IBAction func getPhotoButton(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let image = UIImage(named: "demo")!
        save(post)
        download()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let image = UIImage(named: "demo")!
//        save(post)
//    }
    
    
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
    }
        
        
        
        //4. Save the post caption & download URL
        
//        let databaseRef = database.reference().child("posts")
//        databaseRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
//            let downloadURL = snapshot.value() as! String
//            let storageRef = storage.referenceFromURL(downloadURL)
//            storageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
//                let pic = UIImage(data: data)
//                picArray.append(pic)
//            })
//        })
        
        
        
//        let gsReference = Storage.storage().reference(forURL: "imageDownloadURL")
//        let imageRef = imageStorageRef.child("0C6041CD-D30F-452A-9A04-885AD4E6442C")
//        let localURL = URL (string: "path/to/image")
//        let downloadTask = imageRef.write(toFile: localURL) { URL, error in
//            if let error = error {
//                //oopsie theres an error
//                print("error")
//            } else {
//                print("\(localURL)")
//                //Local file URL for "images/island.jpg" is returned
//            }
//            let observer = downloadTask.observe(.progress) { snapshot in
//
//            }
//        }
        
//        let ref = imageStorageRef.child("0C6041CD-D30F-452A-9A04-885AD4E6442C")
//        let imageView: UIImageView = self.imagePreview
//        let placeholderImage = UIImage(named: "demo")
//        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    
    



    
    func download(){
    if let imageDownloadURL = post.imageDownloadURL{
        let imageStorageReference = Storage.storage().reference(forURL: "imageDownloadURL")
        imageStorageReference.getData(maxSize: 2 * 1024 * 1024, completion: { [weak self](data, error) in
            if let error = error {
                print("error downloading image \(error)")
            } else {
                //success
                print("SUCCESS!!!!")
                if let imageData = data {
                    DispatchQueue.main.async {
                        //imageview
                        let image = UIImage(data: imageData)
                        self?.imagePreview.image = image
                    }
                }
            }
        })
    }
    }
    
    
    
    
}

//    let imageRef = Storage.storage().reference().child("posts").observe(.childAdded)
//    { (snapshot) in
//        print(snapshot.value)
    




    


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        post.image = image
        post.caption = "\(captionText.text!), \(Date().description)"
        dismiss(animated:true, completion: nil)
    }
}

