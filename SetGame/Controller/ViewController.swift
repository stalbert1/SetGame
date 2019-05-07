//
//  ViewController.swift
//  SetGame
//
//  Created by Shane Talbert on 4/7/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var setCardBoard: [SetCardView]! {
        didSet {
            
            print("did set setCardBoard view array called...")
            
            for index in self.setCardBoard.indices {
                //Key here is the tapGestureRecognizer is attaching itself to each of the views.  Could also do this in storyboard.
                //now once if recognizes a tap will start the function tapRecognized in self or the viewController it will pass recognizer which will be the UIGesture recog
                //can use this recognizer.state or .view will know which view had the event...
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(recognizer:)))
                self.setCardBoard[index].addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    @IBOutlet weak var lblMatches: UILabel!
    @IBOutlet weak var lblCardsInDeck: UILabel!
    
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
        setupBoard()
        deckOfCards.printStatsDeckCardStatus()
        
        
    }
    
    func setupBoard() {
        
        //deal the cards
        for index in setCardBoard.indices {
            let tempCard = deckOfCards.deck[index]
            deckOfCards.deck[index].cardStatus = SetCard.CardCondition.onBoard
            setCardBoard[index].newCardDisplayed(card: tempCard)
        }
        
        //reset the scores
        matches = 0
        cardsInDeck = deckOfCards.cardsInDeck
        
        
        
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
        for index in setCardBoard.indices {
            if setCardBoard[index].isSelected {
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
        
        for index in setCardBoard.indices {
            
            if setCardBoard[index].isSelected {
                if let tempSetCard = setCardBoard[index].card {
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
                    for index in setCardBoard.indices {
                        if setCardBoard[index].isSelected {
                            //already checked for nil
                            setCardBoard[index].newCardDisplayed(card: newCard!)
                            setCardBoard[index].isSelected = false
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
            for index in setCardBoard.indices {
                setCardBoard[index].isSelected = false
            }
        }
        
        
    }
    
    func newGame() {
        
        deckOfCards = DeckSetCards()
        setupBoard()
        
    }
    
    
    
    
    //For now this is the new game pressed
    @IBAction func dealCardsPressed() {
        
        newGame()
        
    }
    
}
