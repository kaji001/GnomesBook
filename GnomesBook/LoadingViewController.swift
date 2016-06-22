//
//  LoadingViewController.swift
//  GnomesBook
//
//  Created by Mario Martinez on 18/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicatorView.startAnimation()
    }

    func stopLoading() {
        activityIndicatorView.stopAnimation()
    }
    
    func startLoading() {
        activityIndicatorView.startAnimation()
    }
    
    func nexViewController() {
        self.performSegueWithIdentifier("LoadingViewControllerSegue", sender: nil)
    }
}

