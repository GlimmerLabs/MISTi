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
 
        // Set up various configurations to make the image.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = UInt(4)
        let bitsPerComponent = UInt(8)
        let bytesPerRow = (width * bitsPerComponent * bytesPerPixel + 7) / 8
        
        // Build an array of pixels
        let dataLength = Int(bytesPerRow * height)
        var rawData = Array<UInt8>(count: dataLength, repeatedValue:0)
        var byteIndex = UInt(0);
        
        for (var col = UInt(0); col < width; col++) {
            for (var row = UInt(0); row < height; row++) {
                
                
                // if we're rendering `x`, our grayscale value will be the x position divided by the width
                var color =  (Byte) ((255 * row) / width);
                
                // assign this color to each channel
                rawData[Int(byteIndex)] = color // Red
                rawData[Int(byteIndex + 1)] = color // Green
                rawData[Int(byteIndex + 2)] = color // Blue
                rawData[Int(byteIndex + 3)] = 255 // Alpha
                byteIndex += 4;
            } // for row 
            //endian
        } // for col
        
        
        let bitmapInfo = CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue
        
        // Build the contxt
        let context = CGBitmapContextCreate(&rawData , width, height, bitsPerComponent, bytesPerRow, colorSpace, CGBitmapInfo(bitmapInfo))
        
        var imageRef = CGBitmapContextCreateImage(context)
        let rawImage = UIImage(CGImage: imageRef)
        return rawImage!
    }
    override func viewDidLoad() {
       canvas.image = blendy(400,height: 400);
    }
}
