//
//  ViewController.swift
//  BundleIdentifierBug
//
//  Created by Michael Lehenbauer on 11/18/19.
//  Copyright © 2019 Michael Lehenbauer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    if (Bundle(identifier:"org.cocoapods.grpcpp") != nil) {
      NSLog("Found bundle!")
    }
  }
}

