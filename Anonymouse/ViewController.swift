//
//  ViewController.swift
//  Anonymouse
//
//  Created by Dominic Vernazza on 12/11/16.
//  Copyright © 2016 Dominic Vernazza. All rights reserved.
//

import UIKit

class ViewController: UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("test")
        viewController.viewDidLoad()
        viewController.viewWillAppear(true)
    }
    
}
