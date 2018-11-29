//
//  ViewController.swift
//  Homework 3
//
//  Created by Sameh A Fakhouri on 10/24/18.
//  Copyright © 2018 Sameh A Fakhouri. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {

    lazy var setGame = SetGame()
    
    var setCardViews = [SetCardView]()
    private var selectedCard = [SetCardView]()
    private var hintedCard = [SetCardView]()
    private var cardsNeedsToBeAnimated = [SetCardView]()
    
    @IBOutlet weak var setGameView: UIView! {
        didSet {
            let pinch = UIPinchGestureRecognizer(target: self,
                                                 action: #selector(rearrangeCards(_:)))
            
            let swipeDown = UISwipeGestureRecognizer(target: self,
                                                     action: #selector(dealThreeCards(_:)))
            swipeDown.direction = .down
            
            setGameView.addGestureRecognizer(swipeDown)
            setGameView.addGestureRecognizer(pinch)
            startNewGame()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var plusThree: UIButton!
    @IBOutlet weak var newGameBttn: UIButton!
    
    @IBAction func newGame(_ sender: UIButton) {
        startNewGame()
    }
    
    private func startNewGame() {
        setGame = SetGame()
        updateViewFromModel()
        setCardViews.forEach({
            $0.alpha = 0
            cardsNeedsToBeAnimated.append($0)
        })
        flyInAnimation()
    }
    
    @IBAction func peek(_ sender: UIButton) {
        if setGame.peek() {
            updateViewFromModel()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.setGame.cards.forEach { $0.isSelected = false }
                self.updateViewFromModel()
            })
        } else {
            updateViewFromModel()

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.setGame.cards.forEach { $0.isMisMatched = false }
                self.updateViewFromModel()
            })
        }
    }
    
    @IBAction func addThreeCards(_ sender: UIButton) {
        dealThreeCards()
    }
    
    private func dealThreeCards() {
        setGame.addThreeCards()
        updateViewFromModel()
        
        for index in setGame.cards.count - 3..<setGame.cards.count {
            setCardViews[index].alpha = 0
            cardsNeedsToBeAnimated.append(setCardViews[index])
        }
        
        flyInAnimation()
    }
    
    private func createSetCardViews() {
        setCardViews.forEach({
            $0.removeFromSuperview()
        })
        
        setCardViews = [SetCardView]() 
        
        setGame.cards.forEach({
            let dealToSetGameView = setGameView.convert(plusThree.bounds, from: plusThree)
            let setCardView = SetCardView(frame: dealToSetGameView)
            setCardView.symbolShape = $0.shape
            setCardView.symbolShading = $0.shade
            setCardView.color = $0.color
            setCardView.numberOfSymbols = $0.count
            setCardView.isSelected = $0.isSelected
            setCardView.isMatched = $0.isMatched
            setCardView.isMisMatched = $0.isMisMatched
            setCardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            //assigning tap gesture for each card(view)
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectSetCard(byHandlingGestureRecognizedBy:)))
            setCardView.addGestureRecognizer(tap)
            
            setCardViews.append(setCardView)
        })
        
        //Adding cardview into gameview
        setCardViews.forEach({
            setGameView.addSubview($0)
        })
    }
    
    
    private func updateViewFromModel() {
        createSetCardViews()
        scoreLabel.text = "Score: \(setGame.score)"
        
        if setGame.deck.isEmpty() {
            plusThree.isEnabled = false
            plusThree.isHidden = true
        } else {
            plusThree.isEnabled = true
            plusThree.isHidden = false
        }
    }
    
    @objc private func flyInAnimation() {
        let grid = Grid(for: setGameView.bounds, withNoOfFrames: setGame.cards.count)
    
        var delayTime = 0.0
        for timeOfAnimate in 0..<cardsNeedsToBeAnimated.count {
            let gridIndex = setCardViews.index(of: cardsNeedsToBeAnimated[timeOfAnimate])
            delayTime = 0.1 * Double(timeOfAnimate)
            
            UIView.animate(withDuration: 0.7,
                           delay: delayTime,
                           options: .curveEaseInOut,
                           animations: {
                            self.cardsNeedsToBeAnimated[timeOfAnimate].alpha = 1
                            self.cardsNeedsToBeAnimated[timeOfAnimate].frame = grid[gridIndex!]!
                            
            })
        }
        cardsNeedsToBeAnimated.removeAll()
    }
    
    //Gestures
    @objc func selectSetCard(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer) {
        if let setCardView = recognizer.view as? SetCardView {
            if let cardNumber = setCardViews.index(of: setCardView) {
                setGame.selectCard(at: cardNumber)
                updateViewFromModel()
                
                if (setGame.thereIsASet) {
                    var indexArr = [Int]()
                    
                    for index in self.setCardViews.indices {
                        if self.setCardViews[index].isMatched {
                            UIView.animate(withDuration: 0.5,
                                           animations: {
                                            self.setCardViews[index].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                                            self.view.isUserInteractionEnabled = false
                            },
                                           completion: { _ in
                                            UIView.animate(withDuration: 0.5) {
                                                self.setCardViews[index].transform = CGAffineTransform.identity
                                                indexArr.append(index)
                                            }
                            })
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.setGame.handleLeftOverMatchedCards()
                        self.updateViewFromModel()
                        indexArr.forEach({
                            self.setCardViews[$0].alpha = 0
                            self.cardsNeedsToBeAnimated.append(self.setCardViews[$0])
                        })
                        self.flyInAnimation()
                        self.view.isUserInteractionEnabled = true
                    })
                }
            }
        }
    }
    
    @objc func dealThreeCards(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            setGame.addThreeCards()
            updateViewFromModel()
        default:
            break
        }
    }
    
    @objc func rearrangeCards(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            setGame.rearrangeCards()
            updateViewFromModel()
        default:
            break
        }
    }
    
}

