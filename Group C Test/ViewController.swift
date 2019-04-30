import UIKit
import MobileCoreServices
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
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
   
//    let observer = uploadTask.observe(.progress) { snapshot in
//
//    }
    

    func upload(_ image: UIImage) {
        let storage = Storage.storage()
        let imagesRef = storage.reference(withPath: "image")
        let data = image.jpeg(.medium)!
        imagesRef.putData(data, metadata: nil) { meta, error in
            if (error != nil) {
                print("Error \(error?.localizedDescription)")
            } else {
                print("Upload Complete \(data)")
            }
        }
//        .observe(.progress) { [weak self] (snapshot) in
//            guard let strongSelf = self else { return }
//            guard let progress = snapshot.progress else { return }
//            strongSelf.progressView.progress = Float(progress.fractionCompleted)
//        }
    }
}
    


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        upload(image)
        dismiss(animated:true, completion: nil)
    }
}
