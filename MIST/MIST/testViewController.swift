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
    
    // http://brandontreb.com/image-manipulation-retrieving-and-updating-pixel-values-for-a-uiimage
    func blendy(width:UInt, height:UInt) -> UIImage{
        
        return MIST.createImage(width, height: height, { (row, col, time) -> (UInt8, UInt8, UInt8, UInt8) in
            
            var color =  (Byte) ((255 * row) / width);
            return (color, color, color, 255)
        })
        
    }
    override func viewDidLoad() {
        canvas.image = blendy(400,height: 400);
    }
}
