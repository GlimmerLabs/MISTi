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
        let string = "wsum(mult(x,x),mult(y,y))";
        let exp = MIST.parse(string);
        value.text = string
        canvas.image = MIST.render(exp, height: 100, width: 100);
    }

}
