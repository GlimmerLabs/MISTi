//
//  MISTtoken.swift
//  MIST
//
//  Created by Alex Mitchell on 9/28/14.
//  Copyright (c) 2014 Glimmer Labs. All rights reserved.
//

import UIKit

class MISTtoken: MIST {
    enum types {
        case UNKNOWN
        case OPEN
        case CLOSE
        case COMMA
        case ID
        case NUM
        case EOF
    }
    
    var type: types;
    var text: String;
    var row: Int;
    var col: Int;
    
    init(type: types, text: String, row:Int, col: Int){
        self.type = type
        self.text = text
        self.row = row
        self.col = col
    }
   
    func parseError(text: String, row: Int?, col: Int?){
        if (row != nil) {
            self.row = row!
        }
        if (col != nil){
            self.col = col!
        }
    }
    
}
