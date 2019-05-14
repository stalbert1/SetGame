//
//  SetCardView.swift
//  SetGame
//
//  Created by Shane Talbert on 4/10/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    //In ideal world will want to set only internally public for read only...
    private(set) var card: SetCard?
    
    //Will start off as false.  Everytime it is toggled will update the dispay with or without a border
    public var isSelected: Bool = false {
        didSet {
            
            //oldvalue and newvalue could be used??
            if self.isSelected == true {
                let checkSize: CGFloat = 30.0
                let borderFrame = CGRect(x: bounds.midX - (checkSize / 2), y: bounds.maxY - checkSize, width: checkSize, height: checkSize)
                selectionImageView = UIImageView(frame: borderFrame)
                selectionImageView.image = UIImage(named: "Green_Selection_Check")
                self.addSubview(selectionImageView)
            } else {
                selectionImageView.removeFromSuperview()
            }
            
            
        }
    }
    
    //private computed property to build the name of the asset file
    private var imageName: String {
        
        //var returnedString = ""
        //need to get the raw value but cant
        let returnedString = (self.card?.shape.rawValue)! + (self.card?.color.rawValue)! + (self.card?.shading.rawValue)!
        
        //let returnedString: String = "OvalRedStriped"
        return returnedString
    }
    
    //This is only used so that the VC can ask the view what it is, so that it can update the model...
    var cardThatIsDisplayed: String {
        get {
            if self.card == nil {
                return "Nothing to display"
            } else {
                return self.card!.cardName
            }
        }
    }
    
    //May need to make a public property that will return the name of the card, so that the VC can know what to tell the model...
    
    private var imgView1 = UIImageView()
    private var imgView2 = UIImageView()
    private var imgView3 = UIImageView()
    
    private var selectionImageView = UIImageView()
    
    private lazy var heightOfSymbol = self.bounds.height * 0.55
    private lazy var widthOfSymbol = self.bounds.width * 0.32
    private lazy var yPosOfSymbol = (self.bounds.height / 2) - (self.heightOfSymbol / 2)
    //the xPosOfSymbol will be different depending on if there is 1, 2 or 3 symbols on the card...
    
    //keep in mind this will be a UIView that will be comprised of 1 to 3 images on each view...
    init(frame: CGRect, card: SetCard) {
        //this one can only be called from code...
        super.init(frame: frame)
        self.card = card
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //called if initialized from the storyboard...
        //Will need to call newCardDisplayed to update the card if called from the storyboard...
        
        
 
    }
    
    //This is only meant to be called if initialized through storyboard and want to pass in a card. Frame would been set from storyboard...
    public func newCardDisplayed (card: SetCard) {
        self.card = card
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    public func setup() {
        
        //need to clear all the other views off of the selfView
        imgView1.removeFromSuperview()
        imgView2.removeFromSuperview()
        imgView3.removeFromSuperview()
        
        
        //self.isOpaque = true
        //self.backgroundColor = UIColor(red: 107.0, green: 103.0, blue: 89.0, alpha: 1.0)
        
        //temp to see the card better
        self.backgroundColor = UIColor.white
        //self.isOpaque = false
        
        //build border around the entire card.
        
        if let cardNumber = self.card?.number {
            
            switch cardNumber {
            case .one:
                self.drawOneSymbol()
                
            case .two:
                self.drawTwoSymbols()
                
            case .three:
                self.drawThreeSymbols()
            }
        }
        
        
    }
    
    //This is all unneccnasry only need to make the case for the number of images to draw and will have 3 functions for that...
    
    private func drawOneSymbol() {
        
        
        //self.card?.shape.rawValue
        let xPos: CGFloat = (self.bounds.width / 2) - (self.widthOfSymbol / 2)
        let frame1 = CGRect(x: xPos, y: self.yPosOfSymbol, width: self.widthOfSymbol, height: self.heightOfSymbol)
        imgView1 = UIImageView(frame: frame1)
        imgView1.image = UIImage(named: imageName)
        self.addSubview(imgView1)
        
    }
    
    
    private func drawTwoSymbols() {
        
        let xPos1 = (self.bounds.width / 2) - ((self.widthOfSymbol * 2) / 2)
        let frame1 = CGRect(x: xPos1, y: self.yPosOfSymbol, width: self.widthOfSymbol, height: self.heightOfSymbol)
        imgView1 = UIImageView(frame: frame1)
        imgView1.image = UIImage(named: imageName)
        self.addSubview(imgView1)
        
        let xPos2 = xPos1 + self.widthOfSymbol
        let frame2 = CGRect(x: xPos2, y: self.yPosOfSymbol, width: self.widthOfSymbol, height: self.heightOfSymbol)
        imgView2 = UIImageView(frame: frame2)
        imgView2.image = UIImage(named: imageName)
        self.addSubview(imgView2)
        
    }
    
    private func drawThreeSymbols() {
        
        let xPos1 = (self.bounds.width / 2) - ((self.widthOfSymbol * 3) / 2)
        let frame1 = CGRect(x: xPos1, y: self.yPosOfSymbol, width: self.widthOfSymbol, height: self.heightOfSymbol)
        imgView1 = UIImageView(frame: frame1)
        imgView1.image = UIImage(named: imageName)
        self.addSubview(imgView1)
        
        let xPos2 = xPos1 + self.widthOfSymbol
        let frame2 = CGRect(x: xPos2, y: self.yPosOfSymbol, width: self.widthOfSymbol, height: self.heightOfSymbol)
        imgView2 = UIImageView(frame: frame2)
        imgView2.image = UIImage(named: imageName)
        self.addSubview(imgView2)
        
        let xPos3 = xPos2 + self.widthOfSymbol
        let frame3 = CGRect(x: xPos3, y: self.yPosOfSymbol, width: self.widthOfSymbol, height: self.heightOfSymbol)
        imgView3 = UIImageView(frame: frame3)
        imgView3.image = UIImage(named: imageName)
        self.addSubview(imgView3)
        
    }
    
    
    
}
