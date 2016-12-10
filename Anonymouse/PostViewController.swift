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

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var pics: UIImageView!
    @IBOutlet weak var text: UILabel!
    var mouse = Mouse(id: 1)
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        postText.text! = ""
        mouse.longitude = nil
        mouse.latitude = nil
        mouse.date = NSDate() as Date
        mouse.text = ""
        mouse.picture = nil
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
        mouse.text = postText.text!
        mouse.phoneID = UIDevice.current.identifierForVendor!.uuidString
        print("Mouse Id\(mouse.phoneID)")
        print(mouse.coordinate!)
        postText.text! = ""
        photoImageView.image = nil
        for index in 13...16 {
            AnonyMouseDB.instance.deleteAnonyMouse(aId: Int64(index))
        }
        
        
        
    if let id = AnonyMouseDB.instance.add(anonymice: mouse) {
           mouse.id = id
      }
        var mouseArray: [Mouse] = AnonyMouseDB.instance.getAnonyMouse()
        for mice in mouseArray {
            print(mice.text)
        }
        self.tabBarController?.selectedIndex = 0
        
       
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
        mouse.picture = selectedImage
    }


}

