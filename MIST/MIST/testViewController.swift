//
//  testViewController.swift
//  MIST
//
//  Created by Alex Mitchell on 10/15/14.
//  Copyright (c) 2014 Glimmer Labs. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var value: UILabel!
    
    override func viewDidLoad() {
        canvas.image = MIST.x(50, height: 50)
    }
    
    override func didReceiveMemoryWarning() {
        canvas.image = MIST.y(50, height: 50)
    }
}
