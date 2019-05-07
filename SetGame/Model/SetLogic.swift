//
//  SetLogic.swift
//  SetGame
//
//  Created by Shane Talbert on 4/7/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import Foundation

struct SetLogic {
    
    static func isThisValidSet (card1: SetCard, card2: SetCard, card3: SetCard) -> Bool {
        
        var returnedVal = false
        
        //At the least you will need a set of private functions for each condition...
        //Checking to see if all cards have the same trait
        var boolSame = [Bool]()
        boolSame.append(self.areTheyAllTheSame(s1: card1.color.rawValue, s2: card2.color.rawValue, s3: card3.color.rawValue))
        boolSame.append(self.areTheyAllTheSame(s1: card1.number.rawValue, s2: card2.number.rawValue, s3: card3.number.rawValue))
        boolSame.append(self.areTheyAllTheSame(s1: card1.shape.rawValue, s2: card2.shape.rawValue, s3: card3.shape.rawValue))
        boolSame.append(self.areTheyAllTheSame(s1: card1.shading.rawValue, s2: card2.shading.rawValue, s3: card3.shading.rawValue))
        
        //If 2 cards are the same and 1 card is different in any feature, then it is not a SET
        
        //Checking to see if all 3 cards have unique traits...
        var boolDiff = [Bool]()
        boolDiff.append(self.areTheyAllUnique(s1: card1.color.rawValue, s2: card2.color.rawValue, s3: card3.color.rawValue))
        boolDiff.append(self.areTheyAllUnique(s1: card1.number.rawValue, s2: card2.number.rawValue, s3: card3.number.rawValue))
        boolDiff.append(self.areTheyAllUnique(s1: card1.shape.rawValue, s2: card2.shape.rawValue, s3: card3.shape.rawValue))
        boolDiff.append(self.areTheyAllUnique(s1: card1.shading.rawValue, s2: card2.shading.rawValue, s3: card3.shading.rawValue))
        
        //now how many bools are in a collection??
        var sames = 0
        for item in boolSame {
            if item {
                sames = sames + 1
            }
        }
        
        var diffs = 0
        for item in boolDiff {
            if item {
                diffs = diffs + 1
            }
        }
        
        //here is where my logic will come into play...
        
        /*Rules as such A SET consists of 3 cards in which each of the cards’ features, looked at one‐by‐one, are the same on each card, or, are different on each card. All of the features must separately satisfy this rule. In other words: shape must be either the same on all 3 cards, or different on each of the 3 cards; color must be either the same on all 3 cards, or different on each of the 3, etc. See EXAMPLES below.
         A QUICK CHECK ‐ Is it a SET?
         If 2 cards are the same and 1 card is different in any feature, then it is not a SET. For example, if 2 are red and 1 is purple then it is not a SET. A SET must be either all the same OR all different in each individual feature.*/
        
        //keep in mind this is traits
        if sames + diffs >= 4 {
            returnedVal = true
        } else {
            returnedVal = false
        }
        
        print("sames...\(sames)")
        print("diffs...\(diffs)")
        //if it did not break out of the first 2 conditions it has to be false...
        return returnedVal
        
    }
    
    private static func areTheyAllTheSame (s1: String, s2: String, s3: String) -> Bool {
        var returnedVal = false
        
        if s1 == s2 {
            if s1 == s3 {
                returnedVal = true
            } else {
                returnedVal = false
            }
            
        }
        return returnedVal
    }
    
    private static func areTheyAllUnique (s1: String, s2: String, s3: String) -> Bool {
        var returnedVal = false
        
        if (s1 != s2) && (s1 != s3) && (s2 != s3) {
            returnedVal = true
        } else {
            returnedVal = false
        }
        
        return returnedVal
    }
    
    
}
