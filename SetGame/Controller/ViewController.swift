//
//  ViewController.swift
//  SetGame
//
//  Created by Shane Talbert on 4/7/19.
//  Copyright © 2019 Shane Talbert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblCardsInDeck: UILabel!
    
    //MARK: Instance Variables...
    var cardsInDeck: Int = 0 {
        didSet {
            lblCardsInDeck.text = "Cards In Deck = \(self.cardsInDeck)"
        }
    }
    
    var score: Int = 0 {
        didSet {
            lblScore.text = "Score = \(self.score)"
        }
    }
    
    //This will be increased every time the deals button is used...
    var multiplier: Int = 1
    
    var deckOfCards = DeckSetCards()
    
    //MARK: Variables for the playingTableOfCards UIView setup area
    //This is where all the cards will go...
    @IBOutlet weak var playingTableOfCards: UIView!
    
    //This will be for sizing of the cards and area
    lazy var height = playingTableOfCards.bounds.height
    lazy var width = playingTableOfCards.bounds.width
    
    //42 would be the max for now???
    var cardsToStart: Int = 12
    
    var widthOfCard: CGFloat {
        get {
            var returnedVal: CGFloat = 0
            var cardsPerRow: CGFloat = 4
            
            //need to determine number of cards in each row
            switch cardsToStart {
            case 21...30:
                cardsPerRow = 5
            case 31...42:
                cardsPerRow = 6
            default:
                cardsPerRow = 4
            }
            
            returnedVal = (width - (gap * cardsPerRow)) / cardsPerRow
            return returnedVal
        }
    }
    
    var heightOfCard: CGFloat {
        get {
            var returnedVal: CGFloat = 0
            var columnsInCardGrid: CGFloat = 5
            
            //need to determine the number of cards in each column
            switch cardsToStart {
            case 21...30:
                columnsInCardGrid = 6
            case 31...42:
                columnsInCardGrid = 7
            default:
                columnsInCardGrid = 5
            }
            
            returnedVal = (height - (gap * columnsInCardGrid)) / columnsInCardGrid
            return returnedVal
            
        }
    }
    //This will be the gap between the cards on the board...
    let gap: CGFloat = 4
    
    //This is going to be the array of SetCards that we will use to graphically show the board
    var setBoardCards = [SetCardView]() {
        didSet {
            for index in self.setBoardCards.indices {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized(recognizer:)))
                self.setBoardCards[index].addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    //MARK: Start Of Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //deckOfCards.printStatsDeckCardStatus()
        deal(numberOfCards: cardsToStart)
        
        
    }
    
    //Using this to simplify the problem...
    func placeCardsIntoPositionWithoutAnimation() {
        
        var xPos: CGFloat = gap + (widthOfCard / 2)
        var yPos: CGFloat = gap + (heightOfCard / 2)
        
        for index in setBoardCards.indices {
            if xPos > self.width - (self.widthOfCard / 2) {
                yPos = yPos + self.heightOfCard + self.gap
                xPos = self.gap + (self.widthOfCard / 2)
            }
            self.setBoardCards[index].center.x = xPos
            self.setBoardCards[index].center.y = yPos
            xPos = xPos + self.widthOfCard + self.gap
            
            
            //test
            //self.setBoardCards[index].setup()
        }
        
        
    }
    
    func animateCardsIntoPosition() {
        
        var xPos: CGFloat = gap + (widthOfCard / 2)
        var yPos: CGFloat = gap + (heightOfCard / 2)
        let duration: TimeInterval = 0.3
        var delay: TimeInterval = 0.0
        
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
                delay = delay + 0.3
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
        
        //why does it start the animation 2 times ? This causes each animation to stop 2 times...
        //print("times through is \(timesThrough)")
        
    }
    
    
    func deal(numberOfCards: Int) {
        
        //Creating the actual SetCard View Programmatically, and appending it to the array of SetCardsView...
        for index in 1...numberOfCards {
            //Cards are going to start off life in the discard pile.  Will animate them into the correct position later...
            let newFrame = CGRect(x: 0, y: height - 100, width: widthOfCard, height: heightOfCard)
            let card = deckOfCards.deck[index]
            let cardView = SetCardView(frame: newFrame, card: card)
            setBoardCards.append(cardView)
           
        }
        
        //Let's see if we can see what the diff is between the numberOfCards and the indicies
        //print("setBoardCards.count - numberOfCards = \(cardsToStart - 12)")
        
        
        //setting the setCard onto the playing board and updating the model...
        for index in setBoardCards.indices {
            //this needs to be done, only if you are having to change the size of the cards, cards are 21 or 31??
            let tempCard = deckOfCards.deck[index]
            setBoardCards[index].bounds.size = CGSize(width: widthOfCard, height: heightOfCard)
            setBoardCards[index].removeFromSuperview()
            setBoardCards[index] = SetCardView(frame: setBoardCards[index].frame, card: tempCard)
            
            deckOfCards.deck[index].cardStatus = SetCard.CardCondition.onBoard
            //card needs to start life off in the discard pile.  Move to correct position later
            self.playingTableOfCards.addSubview(self.setBoardCards[index])
        }
   
        print("cards to start is \(cardsToStart)")
        //animateCardsIntoPosition()
        placeCardsIntoPositionWithoutAnimation()
        
        //calling this to update the label to show how many cards are left in the deck
        cardsInDeck = deckOfCards.cardsInDeck
    
        
    }
    
    
    @IBAction func dealMoreCardsPressed(_ sender: UIButton) {
        
        //only want the ability to place 42 cards on the board...
        //also need to make sure cards are left in the deck
        if (cardsToStart < 42 && deckOfCards.cardsInDeck >= 2 ){
            //create a penalty to the score for dealing more cards
            score = score + (multiplier * -2)
            multiplier = multiplier + 1
            
            cardsToStart = cardsToStart + 3
            deal(numberOfCards: 3)
        }
        
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
            //print("Send the 3 cards to see if there is a match then turn all cards to false")
            threeCardsAreSelected()
        }
        
        //check for a winning condition
        if deckOfCards.isGameOver {
            print("appears that the game is over")
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
        //print("is match returned \(isMatched)")
        
        if isMatched {
            //bring out 3 new cards to replace the others
            //3 of the cards in the view are going to be marked as selected
            
            //want to do an animation.  Lets make the cards big, then alpha 0 before getting replaced
            for index in setBoardCards.indices {
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0, delay: 0, options: .curveLinear, animations: {
                    //animations
                    if self.setBoardCards[index].isSelected {
                        //print("in animation loop")
                        self.setBoardCards[index].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                        self.setBoardCards[index].alpha = 0
                    }
                }) { (animatingPosition) in
                    //another animation in the first completion handler
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {
                        //animations
                        self.setBoardCards[index].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.setBoardCards[index].alpha = 1.0
                    }, completion: nil)
                    
                    
                }
                
            }
            
            
            for card in cardsToPass {
                let newCard = self.deckOfCards.markCardAsDiscardedNeedAnotherCard(cardToMarkAsDiscarded: card)
                print("new card added to be discarded \(card.cardName)")
                if newCard == nil {
                    //game is not over at this point.  No cards are left in the deck.  Will simply remove the card from the board
                    
                    for index in setBoardCards.indices {
                        if setBoardCards[index].isSelected {
                            setBoardCards[index].isSelected = false
                            setBoardCards[index].removeFromSuperview()
                        }
                    }
                    
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
            //maybe make more lucrative of score if multiplier is low...
            score = score + (12 - multiplier)
            cardsInDeck = deckOfCards.cardsInDeck
            
            
        } else {
            //setting the view property all to false
            for index in setBoardCards.indices {
                setBoardCards[index].isSelected = false
            }
        }
        
        
    }
    
    
    func newGame() {
        
        //Step 1 would be to first take the score and record it in a high score if applicable.
        
        deckOfCards = DeckSetCards()
        
        for index in setBoardCards.indices {
            setBoardCards[index].removeFromSuperview()
        }
        
        setBoardCards.removeAll()
        cardsToStart = 12
        score = 0
        multiplier = 1
        deal(numberOfCards: cardsToStart)
        
    }
    
    //For now this is the new game pressed
    @IBAction func newGamePressed() {
        
        newGame()
        
    }
    
}
