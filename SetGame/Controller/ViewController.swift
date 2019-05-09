//
//  ViewController.swift
//  SetGame
//
//  Created by Shane Talbert on 4/7/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblMatches: UILabel!
    @IBOutlet weak var lblCardsInDeck: UILabel!
    
    //This is where all the cards will go...
    @IBOutlet weak var playingTableOfCards: UIView!
    
    //This will be for sizing of the cards and area
    lazy var height = playingTableOfCards.bounds.height
    lazy var width = playingTableOfCards.bounds.width
    
    //Right now the grid would take 24 cards 6*4
    //May want to start the number off as 12 and when the count of the array increases change the size of the cards...
    //computed property ?????
    //more than 24 would need to make each row 5
    //more than 30 6 rows...
    // the 4 is the number of rows
    lazy var widthOfCard: CGFloat = (width - (gap * gap + 4)) / 4
    
    
    
    
    
    let gap: CGFloat = 4
    //the 6 here is the number of rows
    lazy var heightOfCard: CGFloat = (height - (gap * gap + 12)) / 6
    //Need to make the height and width of the card dynamic so that it looks at the amount of cards that will be on the board.
    
    //This is going to be the array of SetCards that we will use to graphically show the board
    var setBoardCards = [SetCardView]() {
        didSet {
            for index in self.setBoardCards.indices {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(recognizer:)))
                self.setBoardCards[index].addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    var cardsInDeck: Int = 0 {
        didSet {
            lblCardsInDeck.text = "Cards In Deck = \(self.cardsInDeck)"
        }
    }
    
    var matches: Int = 0 {
        didSet {
            lblMatches.text = "Matches = \(self.matches)"
        }
    }
    
    var deckOfCards = DeckSetCards()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deckOfCards.printStatsDeckCardStatus()
        
        setupBoard()
        
        
    }
    
    func setupBoard() {
        
        
        if setBoardCards.count == 0 {
            dealInitalCards()
        }
        
        //show the cards that are in the array
        for index in setBoardCards.indices {
            let tempCard = deckOfCards.deck[index]
            deckOfCards.deck[index].cardStatus = SetCard.CardCondition.onBoard
            setBoardCards[index].newCardDisplayed(card: tempCard)
            
            //card needs to start life off in the discard pile.  Move to correct position later
            self.playingTableOfCards.addSubview(self.setBoardCards[index])
            
        }
        
        var xPos: CGFloat = gap + (widthOfCard / 2)
        var yPos: CGFloat = gap + (heightOfCard / 2)
        let duration: TimeInterval = 0.8
        var delay: TimeInterval = 0.0
        
        //testing
        //var timesThrough = 0
        //var animateThrough = 0
        
        //would be nice to start with the last one?  Or just have a facedown card
        
        
        
        for index in setBoardCards.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
                //animations
                if xPos > self.width - (self.widthOfCard / 2) {
                    yPos = yPos + self.heightOfCard + self.gap
                    xPos = self.gap + (self.widthOfCard / 2)
                }
                self.setBoardCards[index].center.x = xPos
                self.setBoardCards[index].center.y = yPos
                //duration = duration + 0.1
                delay = delay + 0.5
                xPos = xPos + self.widthOfCard + self.gap
                //animateThrough = animateThrough + 1
                //print("animate through \(animateThrough)")
                
                
            }) { (animatingPosition: UIViewAnimatingPosition) in
                //completion
                //print(animatingPosition.rawValue)
                //timesThrough = timesThrough + 1
                if animatingPosition == .end {
                    //print("animating position ended... timesThrough \(timesThrough)")
                }
            }
            
            
        }
        
        //questions remain???
        //why does it start the animation 2 times ? This causes each animation to stop 2 times...
        //print("times through is \(timesThrough)")
        //reset the scores
        matches = 0
        cardsInDeck = deckOfCards.cardsInDeck
        
    }
    
    /////////////////  TO DO ////////////////////////
    
    //when a match is selected just remove the cards from the board and reshuffle the empty slots.
    //This will probably not work because the indexex of the GUI and the model are married..
    
    
    
    
    
    
    func dealInitalCards() {
        
        
        //lets deal initial cards...
        //Should update the frames for the cards size if this number changes
        for index in 1...20 {
            //Cards are going to start off life in the discard pile.  Will animate them into the correct position later...
            let newFrame = CGRect(x: 0, y: height - 100, width: widthOfCard, height: heightOfCard)
            let card = deckOfCards.deck[index]
            let cardView = SetCardView(frame: newFrame, card: card)
            setBoardCards.append(cardView)
            
        }
        
        setupBoard()
        
    }
    
    @objc func tapRecognized(recognizer: UITapGestureRecognizer) {
        
        //print("tap was received")
        
        //this is marking the view property of the view letting the card know it's selected.
        if recognizer.state == .ended {
            
            if let cardSelected = recognizer.view as? SetCardView {
                print(cardSelected.cardThatIsDisplayed)
                cardSelected.isSelected = !cardSelected.isSelected
            }
            
            
        }//end if recognizer has ended
        
        //count the number of cards selected.  Once youve reached 3 call function to see if they match and then delete all check marks...
        var cardsSelected = 0
        
        //going through index of cardViews to determine how many are selected.
        for index in setBoardCards.indices {
            if setBoardCards[index].isSelected {
                cardsSelected = cardsSelected + 1
            }
        }
        
        if cardsSelected == 3 {
            print("Send the 3 cards to see if there is a match then turn all cards to false")
            threeCardsAreSelected()
        }
        
        
        deckOfCards.printStatsDeckCardStatus()
        
    }
    
    //3 cards are selected determine if they are a match
    func threeCardsAreSelected() {
        
        var cardsToPass = [SetCard]()
        
        for index in setBoardCards.indices {
            
            if setBoardCards[index].isSelected {
                if let tempSetCard = setBoardCards[index].card {
                    cardsToPass.append(tempSetCard)
                }
            }
        }
        
        //Now we have our 3 cards to pass to see if we have a match
        let isMatched = SetLogic.isThisValidSet(card1: cardsToPass[0], card2: cardsToPass[1], card3: cardsToPass[2])
        print("is match returned \(isMatched)")
        
        if isMatched {
            //bring out 3 new cards to replace the others
            //print("deal 3 more cards")
            //3 of the cards in the view are going to be marked as selected
            
            //want to do an animation.  Lets make the cards big, then alpha 0 before getting replaced
            for index in setBoardCards.indices {
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {
                    //animations
                    if self.setBoardCards[index].isSelected {
                        print("in animation loop")
                        //let myVar: CGAffineTransform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                        //self.setBoardCards[index].transform.scaledBy(x: 6.0, y: 6.0)
                        self.setBoardCards[index].transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                    }
                }) { (animatingPosition) in
                    //another animation in the first completion handler
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
                        //animations
                        self.setBoardCards[index].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: nil)
                    
                    
                }
                
            }
            
            
            for card in cardsToPass {
                let newCard = self.deckOfCards.markCardAsDiscardedNeedAnotherCard(cardToMarkAsDiscarded: card)
                print("new card added to be discarded \(card.cardName)")
                if newCard == nil {
                    print("game is over")
                    //start new game
                    newGame()
                    
                } else {
                    //now that we have the card and we have our model marked the view is still in place 3 are selected
                    //update the view
                    for index in setBoardCards.indices {
                        if setBoardCards[index].isSelected {
                            //already checked for nil
                            setBoardCards[index].newCardDisplayed(card: newCard!)
                            setBoardCards[index].isSelected = false
                            //this will break out of the for loop.  I wanto to move on to the next card...
                            break
                        }
                    }
                }
            }//end of is matched
            
            //update matches and cards in deck
            matches = matches + 1
            cardsInDeck = deckOfCards.cardsInDeck
            
            
        } else {
            //setting the view property all to false
            for index in setBoardCards.indices {
                setBoardCards[index].isSelected = false
            }
        }
        
        
    }
    
    
    func newGame() {
        
        deckOfCards = DeckSetCards()
        //setBoardCards = [SetCardView]()
        
        for index in setBoardCards.indices {
            setBoardCards[index].removeFromSuperview()
        }
        
        setBoardCards.removeAll()
        
        setupBoard()
        
    }
    
    //For now this is the new game pressed
    @IBAction func dealCardsPressed() {
        
        newGame()
        
    }
    
}
