//
//  MISTinput.swift
//  MIST
//
//  Created by Alex Mitchell on 9/28/14.
//  Copyright (c) 2014 Glimmer Labs. All rights reserved.
//

import UIKit

class MISTinput: MIST {
    var text: String
    var pos = 0
    var row = 1
    var col = 1
    var len: Int
    init(text:String){
        self.text = text
        self.len = text.utf16Count
    }
    
    func eof ()->Bool{
        return self.pos >= self.len
    } // eof()
    
    func peek() -> String? {
        if (eof()){
            return nil
        }
        else {
            let returnText = text as NSString
            return returnText.substringWithRange(NSRange(location:pos, length:0))
        }
    } // peek()
    
    func next() -> MISTtoken?{
        var c = peek()
        if (c != nil){
            return nil
        }
        else {
            var result = MISTtoken(type: MISTtoken.types.UNKNOWN, text: c!, row: row, col: col)
            ++pos
            ++col
            if (c == "\n"){
                ++row
                col = 1
            }
            return result
        }
    } // next()
    
    func skipWhitespace(){
    }
}
