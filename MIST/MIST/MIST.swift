//
//  MIST.swift
//  MIST
//
//  Created by Alex Mitchell on 10/2/14.
//  Copyright (c) 2014 Glimmer Labs. All rights reserved.
//

import UIKit

public class MIST: NSObject {
    class func evaluate (exp: MIST, dict:Dictionary<String,Double>)->Double{
        if exp is MISTval {
            if let val = dict[(exp as MISTval).name]{
                return val
            }
            else {
                return 0.0
            }
        }
        else if exp is MISTnum {
            var num = exp as MISTnum
            return num.val
        }
        else if exp is MISTapp{ // exp is MISTapp
            
            var app = exp as MISTapp
            var intermediate = [Double]()
            
            for operand in app.operands {
                intermediate.append(evaluate(operand, dict: dict))
            }
            switch app.operation {
            case "wsum", "sum":
                var result:Double = 0
                for (var i = 0; i < intermediate.count; i++){
                    result += intermediate[i]
                }
                if (app.operation == "sum"){
                    return constrain(result)
                }
                else {
                    return wrap(result);
                }
            case "abs":
                return abs(intermediate[0])
            case "sine":
                return wrap(abs(M_PI * intermediate[0]));
            case "mult":
                var result:Double = 1
                for (var i = 0; i < intermediate.count; i++){
                    result *= intermediate[i]
                }
                return constrain(result)
            case "sign":
                if (intermediate[0] < 0){
                    return -1;
                }
                else if (intermediate[0] > 0){
                    return 1
                }
                else {
                    return 0;
                }
            default:
                println("Error: Unknown operation.")
                return 0.0
            }
        }
        else {
            return 0.0;
        }
        
    }
    
    class func constrain (value : Double) -> Double {
        if (value < -1){
            return -1
        }
        else if (value > 1){
            return 1
        }
        else{
            return value
        }
    }
    
    class func wrap (val: Double) -> Double {
        if (val < -1){
            return wrap(val + 2)
        }
        else if (val > 1){
            return wrap(val - 2)
        }
        else{
            return val
        }
    }
    
    class func peekType (tokens: Array<MISTtoken>) -> MISTtoken.types{
        if (tokens.count > 0){
            return tokens[0].type
        }
        else {
            return MISTtoken.types.EOF
        }
    }
    
    class func kernel(inout tokens: Array<MISTtoken>, prefix : String) -> MIST{
        //This should never happen, but let's be safe.
        if tokens.count == 0 {
            println("Unexpected end of input")
        } // if tokens.count == 0
        var tok = tokens.removeAtIndex(0)
        if tok.type == MISTtoken.types.EOF {
            tok.parseError("Unexpected end of input", row: tok.row, col: tok.col)
        }
        else if tok.type == MISTtoken.types.NUM {
            return MISTval(name: tok.text)
        }
        else if tok.type != MISTtoken.types.ID {
            tok.parseError("Unexpected token (" + tok.text + ")", row: tok.row, col: tok.col)
        }
            
        else if peekType(tokens) == MISTtoken.types.OPEN {
            tokens.removeAtIndex(0)
            var children = Array<MIST>()
            while(peekType(tokens) != MISTtoken.types.CLOSE){
                // The real recursion rite here
                if peekType(tokens) == MISTtoken.types.COMMA {
                    tokens.removeAtIndex(0)
                    if (peekType(tokens) == MISTtoken.types.CLOSE) {
                        tokens[0].parseError("Close paren follows comma.", row: tokens[0].row, col: tokens[0].col)
                    } // if there's a close paren after a comma
                } // if there's a comma
                children.append(kernel(&tokens, prefix: prefix))
            } // while
            tokens.removeAtIndex(0)
            return MISTapp(operation: (prefix + tok.text), operands: children)
        }// if it's a function call
            // otherwise it's a singleton
        else {
            return MISTval(name: tok.text)
        }
        // if it's a singleton
        return MIST()
    } // kernel
    
    class func parse (str: String, prefix : String)-> MIST {
        var tokens = tokenize(str)
        var result = kernel(&tokens, prefix: prefix)
        if ((tokens.count > 1) || (peekType(tokens) != MISTtoken.types.EOF)) {
            tokens[0].parseError("Extra text after expression", row: tokens[0].row, col: tokens[0].col)
        }
        return result
        
    } // parse(exp, prefix)
    
    class func parse (exp: String) -> MIST{
        return parse(exp, prefix: "");
    }
    
    class func tokenize (str: String) -> Array<MISTtoken>{
        var tokens = [MISTtoken]()
        var input = MISTinput(text: str);
        input.skipWhitespace()
        while !input.eof(){
            var ch = input.next()!
            if (ch.text == "("){
                ch.type = MISTtoken.types.OPEN
                tokens.append(ch)
            }
            else if (ch.text == ")"){
                ch.type = MISTtoken.types.CLOSE
                tokens.append(ch)
            }
            else if (ch.text == ","){
                ch.type = MISTtoken.types.COMMA
                tokens.append(ch)
            }
            else if (ch.text.rangeOfString("[0-9-.]", options: .RegularExpressionSearch) != nil){
                var num = ch.text
                var dot = false;
                dot = (ch.text == ".")
                var c : Character?
                
                c = input.peek()
                while ((c != nil) && (((c >= "0") && (c <= "9")) || ((!dot) && (c! == ".")))){
                    input.next()
                    num += String(c!)
                    if (c == ".") { dot = true; }
                    c = input.peek()
                } // while
                if (num == "-") {
                    ch.parseError("Singleton negative signs not allowed.", row: ch.row, col: ch.col)
                } // if we only saw a negative sign
                ch.type = MISTtoken.types.NUM;
                ch.text = num;
                tokens.append(ch);
            }
            else if ((ch.text.rangeOfString("[A-Za-z]", options: .RegularExpressionSearch)) != nil) {
                var col = ch.col;
                var row = ch.row;
                var id = ch.text;
                var c : Character?
                c = input.peek();
                
                while ((c != nil) && ((c >= "0" && c <= "9") || (c >= "A" && c <= "Z") || (c >= "a" && c <= "z") || (c == "."))) {
                    id += String(c!);
                    input.next();
                    c = input.peek()
                } // while
                ch.type = MISTtoken.types.ID;
                ch.text = id;
                tokens.append(ch);
            } // if it's an id
            else {
                ch.parseError("Invalid character (" + ch.text + ")", row: ch.row, col: ch.col);
            } // else
        }
        return tokens
    }
    
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
    
    /**
    * Evaluate an expression at a particluar location in a resolution-by-resolution image.
    */
    
    class func render(exp:MIST, height: UInt, width: UInt) -> UIImage{
        return createImage(width, height: height, pixelEqu: { (row, col, time) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) in
            let x = ((Double(col) / Double(width)) * 2) - 1
            let y = ((Double(row) / Double(height)) * 2) - 1
            
            let dict: [String: Double] = ["x": x , "y": y];
            
            let tmp = (MIST.evaluate(exp, dict: dict) + 1) / 2
            
            var component = 255 - (tmp*255);
            
            return (red: UInt8(component), green: UInt8(component), blue: UInt8(component), alpha:255)
        })
    }
}
