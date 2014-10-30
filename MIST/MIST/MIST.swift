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
                deepest = max(deepest, depth((exp as MISTapp).operands[i]!));
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
                if (hasLoop((val as MISTapp).operands[i]!, seen: seen)) {
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
}
