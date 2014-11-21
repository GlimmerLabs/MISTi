//
//  MIST.swift
//  MIST
//
//  Created by Alex Mitchell on 10/2/14.
//  Copyright (c) 2014 Glimmer Labs. All rights reserved.
//

import UIKit

public class MIST: NSObject {
    func depth(exp:MIST) -> Int
    {
        // If it's an application
        if (exp is MISTapp) {
            // Find the deepest child
            var deepest = 0;
            for (var i = 0; i < (exp as MISTapp).operands.count; i++) {
                deepest = max(deepest, depth((exp as MISTapp).operands[i]));
            } // for
            // And add 1
            return 1 + deepest;
        } // if it's an application
            
            // If it's not an application
        else {
            // Then the depth is 1
            return 1;
        } // if it's anything but an application
    } // MIST.depth
    
    func hasLoop(var val: MIST, var seen : Array<MIST>?) -> Bool
    {
        if (seen == nil) { var seen = [MIST](); }
        if (contains(seen!,val)) {
            return true;
        }
        if (val is MISTapp) {
            seen!.append(val)
            for (var i = 0; i < (val as MISTapp).operands.count; i++) {
                if (hasLoop((val as MISTapp).operands[i], seen: seen)) {
                    return true;
                } // if
            } // for
            seen!.removeLast()
        }
        return false;
    } // MIST.hasLoop
    class func colorWithMISTComponents(var red : Float, var green: Float, var blue: Float) -> UIColor{
        red = 1 - (red + 1) / 2
        blue = 1 - (blue + 1) / 2
        green = 1 - (green + 1) / 2
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        
    }
    
    class func createImage(width: UInt, height: UInt, pixelEqu: (row: UInt, col: UInt, time: NSDate) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8)) -> UIImage{
        // http://brandontreb.com/image-manipulation-retrieving-and-updating-pixel-values-for-a-uiimage
        // Set up various configurations to make the image.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = UInt(4)
        let bitsPerComponent = UInt(8)
        let bytesPerRow = (width * bitsPerComponent * bytesPerPixel + 7) / 8
        
        // Build an array of pixels
        let dataLength = Int(bytesPerRow * height)
        var rawData = Array<UInt8>(count: dataLength, repeatedValue:0)
        var byteIndex = UInt(0);
        var time = NSDate()
        
        for (var row = UInt(0); row < height; row++) {
            for (var col = UInt(0); col < width; col++) {
                var pixel = pixelEqu(row: row, col: col, time: time)
                rawData[Int(byteIndex)] = pixel.red // Red
                rawData[Int(byteIndex + 1)] = pixel.green // Green
                rawData[Int(byteIndex + 2)] = pixel.blue // Blue
                rawData[Int(byteIndex + 3)] = pixel.alpha // Alpha
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
    
    class func x(width: UInt, height: UInt)->UIImage{
        return createImage(width, height: height, pixelEqu: { (row, col, time) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) in
            let color = UInt8(255 - ((255 * col) / width))
            return (color, color, color, 255)
        })
    }
    class func y(width: UInt, height: UInt)->UIImage{
        return createImage(width, height: height, pixelEqu: { (row, col, time) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) in
            let color = UInt8(255 - ((255 * row) / width))
            return (color, color, color, 255)
        })
    }
    
    /**
    * Evaluate an expression at a x,y,time, all of which are in the range -1..1.
    */
    /**
    * Evaluate an expression at a particluar location in a width-by-height image.

    class func evalAt(exp:MIST, x: UInt, y: UInt, time: NSDate, width:UInt, height:UInt) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let x = Double(2 * (x - (width  / 2)) / width)
        let y = Double(2 * (y - (height / 2)) / height)
        
        let dict: [String: Double] = ["x": x , "y": y];
        
        let tmp = MISTapp.evaluate(exp, dict: dict);
        
        let component = UInt8(tmp*127.5+127.5);
        
        return (red: component, green: component, blue: component, alpha: 255)
        
    }*/
    
    class func render(exp:MIST, resolution:UInt) -> UIImage{
        return createImage(resolution, height: resolution, pixelEqu: { (row, col, time) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) in
            let x = Double(col) / Double(resolution)
            let y = Double(row) / Double(resolution)
            
            let dict: [String: Double] = ["x": x , "y": y];
            
            let tmp = MISTapp.evaluate(exp, dict: dict);
            
            var component = 255 - (tmp*255);
            
            return (red: UInt8(component), green: UInt8(component), blue: UInt8(component), alpha:255)
        })
    }
}
