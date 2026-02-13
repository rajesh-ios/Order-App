


import UIKit
//import EZSwiftExtensions
import Photos

class CameraGalleryPickerBlock: NSObject , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    typealias onPicked = (UIImage, String) -> ()
    typealias onCanceled = () -> ()
    
    var pickedListner : onPicked?
    var canceledListner : onCanceled?
    
    static let shared = CameraGalleryPickerBlock()
    
    override init(){
        super.init()
    }
    
    deinit{
        
    }
    func pickerImage(isActionSheetOpen : Bool? = true , openMediaType : String? = nil , pickedListner : @escaping onPicked , canceledListner : @escaping onCanceled){
        
        if /isActionSheetOpen {
            UtilityFunctions.sharedInstance.showActionSheetWithStringButtons(buttons: [R.string.localize.camera() , R.string.localize.gallery()], success: {[unowned self] (str) in
                self.openMedia(pickedListner , canceledListner , str)
            })
        }
        else {
            if let str = openMediaType{
                openMedia(pickedListner , canceledListner , str)
            }
        }
    }
    
    
    func openMedia(_ pickedListner : @escaping onPicked , _ canceledListner : @escaping onCanceled , _ type : String) {
        if type == R.string.localize.camera(){
            self.openCamera(pickedListner , canceledListner , type)
            
        } else {
            self.openPhotoGallery(pickedListner , canceledListner , type)
        }
    }
    
    
    func openCamera(_ pickedListner : @escaping onPicked , _ canceledListner : @escaping onCanceled , _ type : String) {
        UtilityFunctions.sharedInstance.isCameraPermission(actionOkButton: { (isOk) in
            if !isOk{
                
                DispatchQueue.main.async {
                    self.showAlert(R.string.localize.settings(), R.string.localize.settingsCameraApp())
                }
                
            }else {
                self.pickedListner = pickedListner
                self.canceledListner = canceledListner
                self.showCameraOrGallery(type: type)
            }
            
        })
    }
    
    func openPhotoGallery(_ pickedListner :  @escaping onPicked , _ canceledListner :  @escaping onCanceled , _ type : String) {
        
        UtilityFunctions.sharedInstance.accessToPhotos(actionOkButton: { (isOk) in
            
            if !isOk{
                DispatchQueue.main.async {
                    self.showAlert(R.string.localize.settings(), R.string.localize.settingsGalleryApp())
                }
            }else {
                self.pickedListner = pickedListner
                self.canceledListner = canceledListner
                
                self.showCameraOrGallery(type: type)
            }
        })
    }
    
    
    
    func showAlert(_ title : String? , _ message : String?){
        
        AlertsClass.shared.showAlertController(withTitle: /title, message: /message, buttonTitles: [R.string.localize.settings(),R.string.localize.cancel()]) { (value) in
            let type = value as AlertTag
            switch type {
            case .yes:
                self.openSettings()
            default:
                return
            }
        }
    }
    
    
    func showCameraOrGallery(type : String){
        
        DispatchQueue.main.async {

            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = /type == R.string.localize.camera() ? UIImagePickerController.SourceType.camera : UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            ez.topMostVC?.present(picker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        if let listener = canceledListner{
            listener()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        var fileName : String?
        if let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            //self.cropImage(image: image)
            guard let data = image.jpegData(compressionQuality: 0.5) else {
                // print("Image not converted into data properly there is some issue")
                return
            }//UIImageJPEGRepresentation(image, 0.5) else { return } less then 4.2 version
            let intMBData = (Double(data.count) / 1024.0) / 1024.0
            //let imageSize: Int = NSData(data: UIImageJPEGRepresentation((image), 0.5)!).length
            let imageSize: Int = NSData(data:image.jpegData(compressionQuality: 0.5)!).length
            
            // print("size of image in KB: %f ", Double(imageSize) / 1024.0)
            if intMBData > 5.0
            {
                Messages.shared.show(alert: .oops, message: "Only image with size less than 5 mb is allowed to be uploaded.", type: .warning)
            }
            else {
                if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                    let assets = result.firstObject
                    if let filename =  assets?.value(forKey: "filename") {
                        fileName = filename as? String
                    }
                }
                
                if let listener = pickedListner{
                    listener(image , /fileName)
                }
            }
            
        }
    }
    
    func openSettings(){
        let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)! as URL
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
}



