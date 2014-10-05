//
//  MISTval.swift
//  MIST
//
//  Created by Alex Mitchell on 9/16/14.
//  Copyright (c) 2014 Glimmer Labs. All rights reserved.
//

import UIKit

public class MISTval: MIST {
    var name: String
    var code :String
    
    public init(name: String){
        self.name = name
        self.code = "" + name
    }
    
    func description() -> String{
        return code
    }
   
}
