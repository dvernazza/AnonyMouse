//
//  FirstViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 11/14/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//
import Darwin
import UIKit
import MapKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate {
    @IBOutlet var postText: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var pics: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet var charsLeftLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    var mouse = Mouse(id: 1)
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postText.delegate = self
        charsLeftLabel.text = "150"
        postText.text! = ""
        mouse.longitude = nil
        mouse.latitude = nil
        mouse.date = NSDate() as Date
        mouse.text = ""
        mouse.picture = ""
        mouse.report = 0
        mouse.score = 0
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func post(_ sender: UIButton) {
        mouse.phoneID = UIDevice.current.identifierForVendor!.uuidString
        let allowedChars = 150
        let charsInTextView = postText.text.characters.count
        let remainingChars = allowedChars - charsInTextView
        if remainingChars < 0 {
            let alert = UIAlertController(title: "Too many words", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
  
        mouse.text = postText.text!
        print("Mouse Id\(mouse.phoneID)")
        print(mouse.coordinate!)
        postText.text! = ""
        photoImageView.image = nil
        if AnonyMouseDB.instance.beenPosted(phoneNumber: mouse.phoneID, textBox: mouse.text) == false {
        if let id = AnonyMouseDB.instance.add(anonymice: mouse) {
           mouse.id = id
            }
        self.tabBarController?.selectedIndex = 0
            }
        else {
            let alert = UIAlertController(title: "You already posted that homie. Try again", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I'll be more creative", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            charsLeftLabel.text? = "150"
        }
        }
}

    @IBAction func addPicture(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        mouse.latitude = locValue.latitude
        mouse.longitude = locValue.longitude
        mouse.coordinate = locValue
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
            }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 150
    }
    
    func checkRemainingChars() {
        let allowedChars = 150
        let charsInTextView = postText.text.characters.count
        let remainingChars = allowedChars - charsInTextView
        charsLeftLabel.text = String(remainingChars)
        if remainingChars <= allowedChars {
            charsLeftLabel.textColor = UIColor.black
        }
        if remainingChars <= 20 {
            charsLeftLabel.textColor = UIColor.orange
        }
        if remainingChars <= 10 {
            charsLeftLabel.textColor = UIColor.red
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        checkRemainingChars()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }


}



