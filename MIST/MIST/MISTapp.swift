//
//  MISTapp.swift
//  MIST
//
//  Created by Alex Mitchell on 9/16/14.
//  Copyright (c) 2014 Glimmer Labs. All rights reserved.
//

import UIKit

public class MISTapp: MIST {
    var operation: String
    var operands: Array<MIST>
    
    convenience override init (){
        self.init(operation: "", operands: [])
    }
    
    init (operation: String, operands: Array<MIST>){
        self.operation = operation
        self.operands = operands
    }
    
        
}