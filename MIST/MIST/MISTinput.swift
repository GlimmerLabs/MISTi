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
    var chars = [Character]();
    var pos = 0
    var row = 1
    var col = 1
    var len: Int
    init(text:String){
        self.text = text
        self.len = text.utf16Count
        for ch in text {
            chars.append(ch)
        } // for ch in text

    }
    
    func eof ()->Bool {
        return self.pos >= self.len
    } // eof()
    
    func peek() -> Character? {
        if (eof()){
            return nil
        }
        else {
            return chars[pos];
        }
    } // peek()
    
    func next() -> MISTtoken? {
        var c = peek()
        if (c == nil){
            return nil
        }
        else {
            var tmp = "";
            tmp.append(c!);
            var result = MISTtoken(type: MISTtoken.types.UNKNOWN, text: tmp, row: row, col: col)
            ++pos
            ++col
            if (c == "\n"){
                ++row
                col = 1
            }
            return result
        }
    } // next()
    
    func skipWhitespace() {
        while(self.peek() == " " || self.peek() == "\t" || self.peek() == "\n"){
            self.next()
        }
        
    }
}
