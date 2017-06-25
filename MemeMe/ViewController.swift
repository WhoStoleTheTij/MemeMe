//
//  ViewController.swift
//  MemeMe
//
//  Created by Richard H on 23/06/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit


struct Meme{
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    var activeTextField: UITextField! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
            NSStrokeWidthAttributeName: -3.0]
        
        self.configureTextfield(textField: topText, defaultAttributes: memeTextAttributes)
        
        self.configureTextfield(textField: bottomText, defaultAttributes: memeTextAttributes)
        
        
    }
    
    //Mark: configure the textfields
    func configureTextfield(textField: UITextField, defaultAttributes: [String:Any]){
        textField.defaultTextAttributes = defaultAttributes
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = true
        textField.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //self.shareButton.isEnabled = false
        
        self.subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unsubscribeToKeyboardNoticifations()
    }
    
    
    // Mark: pick an image from the camera
    @IBAction func pickFromCamera(_ sender: Any) {
        
        self.pickImage(sourceType: .camera)
        
    }
    
    // Mark: pick an image from the photo album
    @IBAction func pickFromAlbum(_ sender: Any) {
        self.pickImage(sourceType: .photoLibrary)
        
        
    }
    
    //Mark: image is/is not picked from the photo album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            self.shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)

        }
        
    }
    
    //Mark: pick an image from sourceType
    func pickImage(sourceType: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion:nil)
    }
    
    //Mark: dismiss the image picker controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    //Mark: begin editting the text in the top textfield
    @IBAction func beginTopText(_ sender: UITextField){
        
        let text = sender.text
        
        if text == "Top" {
            sender.text = ""
        }
        
        sender.becomeFirstResponder()
        
        
    }
    
    //Mark: end editting in the top textfield
    @IBAction func endTopText(_ sender: UITextField){
        
        let text = sender.text
        
        if text == "" {
            sender.text = "Top"
        }
        
        sender.resignFirstResponder()
        
    }
    
    //Mar: setup the keyboard hide/show subscriptions
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object:nil)
    }
    
    //Mark: remove the keyboard hide/show subscriptions
    func unsubscribeToKeyboardNoticifations(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object:nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object:nil)
    }
    
    //Mark: called when the keyboard shows
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
    }
    
    //Mark: called when the keyboard hides
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    //Mark: get the height of the keyboard - will return zero if the activeTextfield is not the bottom textfield
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let returnValue: CGFloat!
        
        if self.activeTextField != nil && self.activeTextField.tag == 2{
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            returnValue = keyboardSize.cgRectValue.height
        }else{
            returnValue = CGFloat(0)
        }
        
        
        return returnValue
    }
    
    
    
    //Mark: begin editting the bottom textfield
    @IBAction func beginBottomText(_ sender: UITextField){
        
        let text = sender.text
        
        if(text == "Bottom"){
            sender.text = ""
        }
        
        sender.becomeFirstResponder()
        
        self.activeTextField = sender
        
    }
    
    //Mark: end editting in the bottom textfield
    @IBAction func endBottomText(_ sender: UITextField){
        
        let text = sender.text
        
        if text == "" {
            sender.text = "Bottom"
        }
        
        
        sender.resignFirstResponder()
        
        self.activeTextField = nil
        
    }
    
    //Mark: dismiss the keyboard when the enter key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Mark: hide the status bar - had to force the status bar to hide as other settings were not working
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //Mark: generate the meme image
    func generateMemedImage() -> UIImage{
        
        self.topBar.isHidden = true;
        self.bottomBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates:true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.topBar.isHidden = false;
        self.bottomBar.isHidden = false
        
        return memedImage
        
    }
    
    //Mark: save the meme
    func save(memedImage: UIImage){
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    
    //Mark: share the meme button function
    @IBAction func shareAction(_ sender: Any) {
        
        let memedImage = self.generateMemedImage()
        
        let actionController = UIActivityViewController(activityItems:[memedImage], applicationActivities: nil)
        
        actionController.completionWithItemsHandler = {
            (_, successful, _, _) -> Void in
            
            if successful{
                self.save(memedImage: memedImage)
            }
            
        }
        
        self.present(actionController, animated: true, completion:nil)
        
        
        
    }
    
    
}

