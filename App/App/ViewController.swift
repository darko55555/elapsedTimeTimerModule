//
//  ViewController.swift
//  App
//
//  Created by Darko Dujmovic on 30/01/2020.
//  Copyright © 2020 Darko Dujmovic. All rights reserved.
//

import UIKit
import Messaging

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Messaging().returnSomething(forText: "Darko"))
    }


}

