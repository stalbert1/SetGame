//
//  DeckSetCards.swift
//  SetGame
//
//  Created by Shane Talbert on 4/7/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import Foundation

struct DeckSetCards {
    
    //This will be the deck of cards
    var deck = [SetCard]()
    
    //calculated property that returns .inDeck
    var cardsInDeck: Int {
        var returnedNumber = 0
        
        for card in self.deck {
            if card.cardStatus == .inDeck {
                returnedNumber = returnedNumber + 1
            }
        }
        return returnedNumber
    }
    
    //calculated property that determines if the game is over.  Right now will only return true if you have a perfect win game
    var isGameOver: Bool {
        
        var discardCout = 0
        var inDeckCount = 0
        var onBoardCount = 0
        
        for card in self.deck {
            switch card.cardStatus {
            case .discarded:
                discardCout = discardCout + 1
            case .inDeck:
                inDeckCount = inDeckCount + 1
            case .onBoard:
                onBoardCount = onBoardCount + 1
                
            }
        }
        
        if (inDeckCount == 0 && onBoardCount == 0 && discardCout == 81) {
            return true
        } else {
            return false
        }
        
    }
    
    init() {
        // Will need to loop through using the 4 static Vars in the setCard Class to create a single deck of 81 cards?
        
        for cardNumber in SetCard.validNumbers {
            for cardColor in SetCard.validColors {
                for cardShading in SetCard.validShading {
                    for cardShape in SetCard.validShapes {
                        let tempString = cardNumber + cardColor + cardShading + cardShape
                        //let tempCard = SetCard(cardName: tempString)
                        let tempCard = SetCard(cardName: tempString, cardStatus: .inDeck)
                        //now that we have the card can place in the deck
                        deck.append(tempCard)
                    }
                }
            }
        }
        //shuffle the deck
        self.deck.shuffle()
    }// End init
    
    
    //function that will take a card as an arg and will return a card to replace it with if there is a card in the deck
    //mark the card that is passed in as played?? as a property on the card...
    mutating func markCardAsDiscardedNeedAnotherCard (cardToMarkAsDiscarded: SetCard) -> SetCard? {
        
        //will need to find the card that was in the onBoard pile and mark it as discarded before returning card
        for index in self.deck.indices {
            if cardToMarkAsDiscarded.cardName == self.deck[index].cardName {
                //we have a match
                self.deck[index].cardStatus = .discarded
            }
        }
        
        
        
        //determine if deck has any cards that are marked as played?
        for index in self.deck.indices {
            if self.deck[index].cardStatus == .inDeck {
                //we will grab the first card that is in the deck, since they are shuffled
                //will need to mark it as on the board first
                self.deck[index].cardStatus = SetCard.CardCondition.onBoard
                return self.deck[index]
            }
        }
        //scratch that will need to mark a card as played once it hits the playing board..
        
        //This means no cards were found
        return nil
        
    }
    
    //Function for troubleshooting
    func showDeckCards() {
        for card in self.deck {
            print("\(card.cardName)")
        }
    }
    
    //Function for troubleshooting
    func printStatsDeckCardStatus() {
        var discardCout = 0
        var inDeckCount = 0
        var onBoardCount = 0
        
        for card in self.deck {
            switch card.cardStatus {
            case .discarded:
                discardCout = discardCout + 1
            case .inDeck:
                inDeckCount = inDeckCount + 1
            case .onBoard:
                onBoardCount = onBoardCount + 1
                
            }
        }
        
        print("Card count of deck is... In Deck = \(inDeckCount);  On the Board = \(onBoardCount);  Discarded = \(discardCout)")
    }
    
    
}
