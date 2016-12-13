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

class PostViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate, UITabBarControllerDelegate {
    @IBOutlet var postText: UITextView!
    @IBOutlet var charsLeftLabel: UILabel!
    var mouse = Mouse(id: 1)
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postText.delegate = self
        charsLeftLabel.text = "150"
        charsLeftLabel.textColor = UIColor.black
        postText.text! = ""
        mouse.longitude = nil
        mouse.latitude = nil
        mouse.text = ""
        mouse.report = 0
        mouse.score = 0
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()    
        }

    if let navigationBar = self.navigationController?.navigationBar {
        let secondFrame = CGRect(x: (navigationBar.frame.width/2)-(navigationBar.frame.width/9), y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
        let secondLabel = UILabel(frame: secondFrame)
        secondLabel.text = "Post"
        navigationBar.addSubview(secondLabel)
    }
    }

    override func viewWillAppear(_ animated: Bool) {
        charsLeftLabel.text = "150"
        charsLeftLabel.text = "150"
        charsLeftLabel.textColor = UIColor.black
        postText.text! = ""
        mouse.longitude = nil
        mouse.latitude = nil
        mouse.text = ""
        mouse.report = 0
        mouse.score = 0
        
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
            
            let today: Date = Date()
            let expiration = Calendar.current.date(byAdding: .day, value: 3, to: today)
            mouse.date = expiration!
            mouse.text = postText.text!
            if AnonyMouseDB.instance.beenPosted(phoneNumber: mouse.phoneID, textBox: mouse.text) == false {
            if let id = AnonyMouseDB.instance.add(anonymice: mouse) {
                AnonyMouseDB.instance.addMine(anonymice: mouse)
                mouse.id = id
            }
            charsLeftLabel.text? = "Characters Left: 150"
        
            self.tabBarController?.selectedIndex = 0
            
                
            } else {
                
            let alert = UIAlertController(title: "You already posted that homie. Try again", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I'll be more creative", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            charsLeftLabel.text? = "150"
        }
        }
}

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        mouse.latitude = locValue.latitude
        mouse.longitude = locValue.longitude
        mouse.coordinate = locValue
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



