//
//  SetCard.swift
//  SetGame
//
//  Created by Shane Talbert on 4/7/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import Foundation

struct SetCard {

    static var validShapes = ["Diamond", "Squiggle", "Oval"]
    static var validColors = ["Red", "Purple", "Green"]
    static var validNumbers = ["1", "2", "3"]
    static var validShading = ["Solid", "Striped", "Outlined"]
    
    //This will be a string name of combined 1 of each 1RedSolidDiamond in this format which will call the correct graphic.  The deck class will create the instance of the card...
    //This should be private.  Maybe an optional
    var cardName: String
    
    //will start off each card as .inDeck, once it hits the board will be .onBoard then once matched will be .discarded
    var cardStatus: CardCondition = .inDeck
    
    //These will be computed properties that will return the type of enum based on string interpolation of the stored property cardName
    var shape: Shape {
        //["Diamond", "Squiggle", "Oval"]
        var returnedShape: Shape = .diamond
        
        if self.cardName.contains("Diamond") {
            returnedShape = .diamond
        }
        if self.cardName.contains("Squiggle") {
            returnedShape = .squiggle
        }
        if self.cardName.contains("Oval") {
            returnedShape = .oval
        }
        
        return returnedShape
        
    }
    
    var color: Color {
        //["Red", "Purple", "Green"]
        var returnedColor: Color = .green
        
        if self.cardName.contains("Red") {
            returnedColor = .red
        }
        if self.cardName.contains("Purple") {
            returnedColor = .purple
        }
        if self.cardName.contains("Green") {
            returnedColor = .green
        }
        
        return returnedColor
    }
    
    var number: Number {
        //["1", "2", "3"]
        var returnedNumber: Number = .one
        
        if self.cardName.contains("1") {
            returnedNumber = .one
        }
        if self.cardName.contains("2") {
            returnedNumber = .two
        }
        if self.cardName.contains("3") {
            returnedNumber = .three
        }
        
        return returnedNumber
    }
    
    var shading: Shading {
        //["Solid", "Striped", "Outlined"]
        var returnedShade: Shading = .outlined
        
        if self.cardName.contains("Solid") {
            returnedShade = .solid
        }
        if self.cardName.contains("Striped") {
            returnedShade = .striped
        }
        if self.cardName.contains("Outlined") {
            returnedShade = .outlined
        }
        
        return returnedShade
    }
    
    
}

extension SetCard {
    
    //This is assiging a raw value to each type that can be more easily matched
    //Should these be private???  May be confusing to see them as a list on the SetCard Struct???
    enum Shape: String {
        case diamond = "Diamond"
        case squiggle = "Squiggle"
        case oval = "Oval"
    }
    
    enum Color: String {
        case red = "Red"
        case purple = "Purple"
        case green = "Green"
    }
    
    enum Number: String {
        case one = "One"
        case two = "Two"
        case three = "Three"
    }
    
    enum Shading: String {
        case solid = "Solid"
        case striped = "Striped"
        case outlined = "Outlined"
    }
    
    enum CardCondition {
        case inDeck
        case onBoard
        case discarded
    }
    
    
}

