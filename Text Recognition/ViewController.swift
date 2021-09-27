//
//  ViewController.swift
//  Text Recognition
//

import Vision
import UIKit
import Photos
import MobileCoreServices
import AssetsLibrary
extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
                        .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func btnchangeImge(_ sender: UIButton) {
        self.lblcarddetail.textColor = UIColor.black
        self.lblcardno.textColor = UIColor.black
        self.lblcardname.textColor = UIColor.black
        self.lblcardExp.textColor = UIColor.black
        CarddetailLabel.isHidden = false
        self.lblcarddetail.isHidden = false
        self.lblcardno.isHidden = false
        self.lblcardname.isHidden = false
        self.lblcardExp.isHidden = false

        if lblsaveCard.title(for: .normal) == "Scan card"{
            imageRecognition(image: imageView.image)
            lblsaveCard.setTitle("Save card", for: .normal)
            lblsavedCard.setTitle("Reset", for: .normal)
        }
        else{
        
    
        db.insert(id: 0, Cardname: lblcardExp.text ?? "No Name", Cardnumber:  lblcarddetail.text ?? "0", CardExp: lblcardname.text ?? "No date")
       lblsaveCard.setTitle("Scan card", for: .normal)
        lblsavedCard.setTitle("Saved Cards", for: .normal)
        }
        


    }
    
    @IBAction func btnSavedcard(_ sender: Any) {
        if lblsavedCard.title(for: .normal) == "Reset"
        {
            self.lblcarddetail.textColor = UIColor.lightGray
            self.lblcardno.textColor = UIColor.lightGray
            self.lblcardname.textColor = UIColor.lightGray
            self.lblcardExp.textColor = UIColor.lightGray
            
            self.lblcarddetail.text = "Card Number"
            self.lblcardno.text = "Card Type"
            self.lblcardname.text = "Expiry"
            self.lblcardExp.text = "Card Holder Name"
          
            lblsaveCard.setTitle("Scan card", for: .normal)
            lblsavedCard.setTitle("Saved Cards", for: .normal)
            //lblsavedCard.setTitle("Reset", for: .normal)
        }
        else{
          let cards =   db.read()
            if cards.count == 0{
                Toast(Title: "", Text: "No saved card", delay: 1)
            }
            else{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           let vc = storyboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController

                           self.navigationController?.navigationBar.isHidden = true
                           self.navigationController?.pushViewController(vc,
                                                                         animated: true)
            }}}
    private var picker = UIImagePickerController()
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblsavedCard: UIButton!
    func openImageFromLibrary() {
          picker.allowsEditing = false
          picker.sourceType = .photoLibrary
          picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
          picker.modalPresentationStyle = .fullScreen
          picker.delegate = self
          present(picker, animated: true, completion: nil)
      }
    @IBOutlet weak var lblsaveCard: UIButton!
    
      func openImageFromCamera() {
          if UIImagePickerController.isSourceTypeAvailable(.camera) {
            

            
            picker.allowsEditing = false
            
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
          
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
         
            present(picker,animated: true,completion: nil)
          } else {
              noCamera()
          }
      }
      
      func noCamera(){
          let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
          alertVC.addAction(okAction)
          present(alertVC, animated: true, completion: nil)
      }
      
      
      private func showAlert() {
          let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
          alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
              self.getImage(fromSourceType: .camera)
          }))
          alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
              self.getImage(fromSourceType: .photoLibrary)
          }))
          alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
      func Toast(Title:String ,Text:String, delay:Int) -> Void {
            let alert = UIAlertController(title: Title, message: Text, preferredStyle: .alert)
            present(alert, animated: true)
            let deadlineTime = DispatchTime.now() + .seconds(delay)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
      //get image from source type
      private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
          
          //Check is source type available
          if UIImagePickerController.isSourceTypeAvailable(sourceType) {
              
              let imagePickerController = UIImagePickerController()
              imagePickerController.delegate = self
              
              imagePickerController.sourceType = .photoLibrary
              if(imagePickerController.sourceType == .photoLibrary){
                  imagePickerController.allowsEditing = false
                  imagePickerController.sourceType = .photoLibrary
                  
                  self.present(imagePickerController, animated: true, completion: nil)
              }
              else{
                  imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                  imagePickerController.cameraCaptureMode = .photo
                  imagePickerController.modalPresentationStyle = .fullScreen
                  present(imagePickerController,animated: true,completion: nil)
              }
              
          }
          else   if UIImagePickerController.isSourceTypeAvailable(.camera)
          {
              let imagePickerController = UIImagePickerController()
              if UIImagePickerController.isSourceTypeAvailable(.camera) {
                  imagePickerController.allowsEditing = false
                  imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                  imagePickerController.cameraCaptureMode = .photo
                  imagePickerController.modalPresentationStyle = .fullScreen
                  present(imagePickerController,animated: true,completion: nil)
              } else {
                  noCamera()
              }
          }
          noCamera()
      }
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
      }
    var imageData = Data()
    
    var imgurl = NSURL()
     var newImageSize: Data?
//      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//         {
//           //  let image: UIImage = UIImage(data: imageData)!
//
////        guard let image = info[.editedImage] as? UIImage else {
////            print("No image found")
////            return
////        }
//
//        // print out the image size as a test
//   //     print(image.size)
//          //  imgurl = info[UIImagePickerController.InfoKey.PHPicker] as! NSURL
//
//   // print(imgurl)
//
//        imageView.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
//
//
//         imageData = (imageView.image?.jpegData(compressionQuality: 1))!
//
//
//        self.dismiss(animated: true, completion: nil)
//      //  imageView.transform = imageView.transform.rotated(by: .pi/1.5)
//        imageRecognition(image: imageView.image)
//         }
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
           // present(picker, animated: true, completion: nil)
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                  //  self.present(self.picker, animated: true, completion: nil)
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        case .limited:
            print("User has denied the permission.")
        @unknown default:
            print("User has denied the permission.")
        }
    }
    
  
    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//       // imageView.image = UIImage(named:example1)
//   // imageView.image = UIImage(named: "example1")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//imageView.frame = CGRect(x: 20,
//                                 y: view.safeAreaInsets.top,
//                                 width: view.frame.size.width-40,
//                                 height:  view.frame.size.width-40)
//
    
    }
    @IBOutlet weak var CarddetailLabel: UILabel!
    var db:DBHelper = DBHelper()
    @IBOutlet weak var lblcardExp: UITextView!
    @IBOutlet weak var lblcardname: UITextView!
    @IBOutlet weak var lblcardno: UITextView!
    @IBOutlet weak var lblcarddetail: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblcarddetail.isHidden = true
        self.lblcardno.isHidden = true
        self.lblcardname.isHidden = true
        self.lblcardExp.isHidden = true
        CarddetailLabel.isHidden = true
        
        self.lblcarddetail.textColor = UIColor.lightGray
        self.lblcardno.textColor = UIColor.lightGray
        self.lblcardname.textColor = UIColor.lightGray
        self.lblcardExp.textColor = UIColor.lightGray
        self.lblcarddetail.text = "Card Number"
        self.lblcardno.text = "Card Type"
        self.lblcardname.text = "Expiry"
        self.lblcardExp.text = "Card Holder Name"
        
        lblcardno.layer.cornerRadius = 3
        lblcardname.layer.cornerRadius = 3
        lblcarddetail.layer.cornerRadius = 3
        lblcardExp.layer.cornerRadius = 3
        
        lblsaveCard.layer.cornerRadius = 3
        lblsavedCard.layer.cornerRadius = 3
        
        
        if  self.lblcarddetail.text == "Card Number"
        {
            lblsavedCard.setTitle("Saved Cards", for: .normal)
        }
        else{
            lblsavedCard.setTitle("Reset", for: .normal)
        }
        // Do any additional setup after loading the view.
        
     //   view.addSubview(label)
//        view.addSubview(imageView)
//
    
   }
    private func imageRecognition(image: UIImage? ){
        guard let cgImage = image?.cgImage else { return }
        
        //handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
    
        //request
    
        let request = VNRecognizeTextRequest { [weak self] request , error in
        
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                return
            }
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            
            }).joined(separator: "\n ")
            print(text + "seperator")

            let text1 = observations.compactMap({
                $0.topCandidates(1).first?.string
            
            })
            
            let last4 = String(text1[4].suffix(5))
          
            

        
            DispatchQueue.main.async {
 
                self?.lblcarddetail.text = text1[2]
                self?.lblcardno.text = text1[0]
                self?.lblcardname.text = last4
                self?.lblcardExp.text = text1[5]
                
            }
        }
        
        
        //process
        
        do {
           
            try handler.perform([request])
        } catch  {
            print(error)
        }
        
        
    }

}

