//
//  FirstViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 11/14/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var pics: UIImageView!
    @IBOutlet weak var text: UILabel!
    var mouse = Mouse()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        postText.text! = ""
        mouse.coordinate = nil
        mouse.date = NSDate() as Date
        mouse.text = ""
        mouse.picture = nil
        mouse.report = 0
        mouse.score = 0
        self.locationManager.requestAlwaysAuthorization()
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

        print(mouse.text)
        print(mouse.coordinate)
        pics.image = mouse.picture
        print(mouse.date)
        
    }
    @IBAction func addPicture(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
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

