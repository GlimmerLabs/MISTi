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
    @IBOutlet weak var resSlider: UISlider!
    
    
    
    @IBAction func didClickXButton(sender: AnyObject) {
    }

    @IBAction func didClickYButton(sender: AnyObject) {
    }
    override func viewDidLoad() {
        let exp = MISTapp.parse("x");
        canvas.image = MIST.render(exp, resolution: 100);
    }

}
