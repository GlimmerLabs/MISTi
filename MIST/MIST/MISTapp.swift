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
    var operands: Array<MIST?>

    
    override init (){
        self.operation = ""
        self.operands = []
    }
    
    init (operation: String, operands: Array<MIST?>){
        self.operation = operation
        self.operands = operands
    }
    
    class func evaluate (exp: MIST, dict:Dictionary<String,Double>)->Double{
        if exp is MISTval {
            var val = exp as MISTval
            return dict[val.name]!
        }
        else if exp is MISTnum {
            var num = exp as MISTnum
            return num.val
        }
        else { // exp is MISTapp
            
            var app = exp as MISTapp
            var intermediate = [Double]()
            
            for i in 0...app.operands.count {
                intermediate[i] = self.evaluate(app.operands[i]!, dict: dict)
            }
            switch app.operation {
            case "wsum", "sum":
                var result:Double = 0
                for i in 0...intermediate.count {
                    result += intermediate[i]
                }
                if (app.operation == "sum"){
                    return result
                }
                else {
                    return wrap(result);
                }
            case "abs":
                return abs(intermediate[0])
            case "sine":
                return abs(M_1_PI * intermediate[0]);
            default:
                println("Error: Unknown operation.")
                return 0.0
            }
        }
    }
    
    class func wrap (val: Double) ->Double {
        // Need to be completed.
        parse("dog")
        return 0.1
    }
    
    
    
    class func peekType (tokens: Array<MISTtoken?>) -> MISTtoken.types{
        if (tokens[0] == nil) {
            return MISTtoken.types.UNKNOWN
        }
        else {
            return tokens[0]!.type
        }
        
    }
    
    class func kernel(var tokens: Array<MISTtoken?>, prefix : String) -> MIST{
        //This should never happen, but let's be safe.
        if tokens.count == 0 {
            println("Unexpected end of input")
        } // if tokens.count == 0
        var tok: MISTtoken! = tokens.removeAtIndex(0)
        if tok!.type == MISTtoken.types.EOF {
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
            var children = Array<MIST?>()
            while(peekType(tokens) != MISTtoken.types.CLOSE){
                // The real recursion rite here
                children.append(kernel(tokens, prefix: prefix))
                if peekType(tokens) == MISTtoken.types.COMMA {
                    tokens.removeAtIndex(0)
                    if (peekType(tokens) == MISTtoken.types.CLOSE) {
                        tokens[0]!.parseError("Close paren follows comma.", row: tokens[0]!.row, col: tokens[0]!.col)
                    } // if there's a close parem after a comma
                } // if there's a comma
            } // while
            tokens.removeAtIndex(0)
            return MISTapp(operation: (prefix + tok.text), operands: children)
        }// if it's a function call
            // otherwise it's a singleton
        else {
            return MISTval(name: tok.text)
        } // if it's a singleton
        return MISTval(name: tok.text);
    } // kernel

    
    class func parse (str: String, prefix : String)-> MIST {
        var tokens = tokenize(str)
        var result = kernel(tokens, prefix: prefix)
        if ((tokens.count > 1) || (peekType(tokens) != MISTtoken.types.EOF)) {
            tokens[0].parseError("Extra text after expression", row: tokens[0].row, col: tokens[0].col)
        }
        return result
        
    } // parse(exp, prefix)
    
    public class func parse (exp: String){
        parse(exp, prefix: "");
    }
    
    class func tokenize (str: String) -> Array<MISTtoken>{
        var tokens = []
        var input = MISTinput(text: str);
        
        
        return []
    }
    
    
    
}