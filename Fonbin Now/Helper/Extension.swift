
import Foundation
import UIKit
import JGProgressHUD
import SDWebImage
import GoogleMaps


let hud = JGProgressHUD()

extension UIColor{

    public class var Primary_Blue : UIColor {
        return UIColor(red:0.13, green:0.20, blue:0.35, alpha:1.00)
    }
    public class var Secondary_Blue : UIColor {
        return UIColor(red:0.24, green:0.38, blue:0.61, alpha:1.00)
    }
    public class var appRed : UIColor {
        return UIColor(named: "appRed")!
    }
    public class var appBlack : UIColor {
        return UIColor.black
    }
    public class var appDimRed : UIColor {
        return UIColor(named: "appDimRed")!
    }
}
extension URL {
    static func getBaseUrlStr() -> String {
          guard let info = Bundle.main.infoDictionary,
            let urlString = info["Base URL"] as? String else{
              fatalError("Cannot get base url from info.plist")
          }
          return urlString
      }
}
extension String{
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
   static func random(length: Int = 20) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
extension UIView {

    func roundTopCurve(cornerRadius : CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner] //Top Right , Top Left Respectively
    }
    func roundCurve(cornerRadius : CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMaxXMaxYCorner] //Top Right , Bottom Right Respectively
    }
    func makeRound(cornerRadius : CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    func makeCircle(){
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    func dropCardView(){
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.5
    }
    func dropTextFeildCardView(){
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.backgroundColor = .appDimRed
    }
    }

extension UITextField {
func setLeftPaddingPoints(_ amount:CGFloat){
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
}
func setRightPaddingPoints(_ amount:CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.rightView = paddingView
    self.rightViewMode = .always
}
  func MakeOTPFeild(){
      self.layer.borderColor = UIColor.black.cgColor
      self.layer.borderWidth = 1
      self.layer.cornerRadius = 12
  }
    func changePlaceHolder (PlaceHoldertxt : String , Color : UIColor){
        self.attributedPlaceholder = NSAttributedString(string: PlaceHoldertxt,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}
extension UIViewController{
    func openVC(_ identifier : String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller  = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(controller, animated: true)
    }
    func showAlertView(message : String,title : String){
         let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
         alertController.addAction(UIAlertAction(title: "Ok" , style: UIAlertAction.Style.default,handler: nil))
         present(alertController, animated: false, completion: nil)
     }
    func showAlertView(message : String,title : String,action : UIAlertAction){
        let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(action)
        present(alertController, animated: false, completion: nil)
    }
    
    func showAlert(_ title: String, _ message:String , completion: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
            completion()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    func showAlertWithSingleButton(_ title: String, _ message:String , completion: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
            completion()
        })
        alert.addAction(ok)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showAlertWithDobuleButton(_ title: String, _ message:String , completion: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
           
        })
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
            completion()
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showLoadingView(){
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    func hideLoadingView(){
        hud.dismiss()
    }
}
extension UIImage {
    /// Fix image orientaton to protrait up
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }

        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }

        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError("Missing...")
            break
        }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }

        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
extension UIImage {
    func resized(to size : CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        //disable HDR:
        format.preferredRange = .standard
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let result = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        }
        return result
    }
}
extension UIImageView{
    func downloadImage(url:String){
      //remove space if a url contains.
        let stringWithoutWhitespace = url.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage())
    }
}
extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
