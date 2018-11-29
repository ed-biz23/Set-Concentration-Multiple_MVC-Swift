//
//  SetCardGame.swift
//  Homework 2
//
//  Created by Sameh Fakhouri on 10/5/18.
//  Copyright © 2018 CUNY Lehman College. All rights reserved.
//

import Foundation

class SetGame {
    
    var deck = SetCardDeck()
    
    var cards = [SetCard]()
    
    var score = 0
    
    var thereIsASet = false
    
    private var selectedCards = [SetCard]()
    
    
    func selectCard(at index: Int) {

        handleLeftOverMatchedCards()
        
        if (index <= cards.count) {
            if (cards[index].isSelected) {
                cards[index].isSelected = false
                if let removeIndex = selectedCards.index(of: cards[index]) {
                    selectedCards.remove(at: removeIndex)
                }
            } else {
                cards[index].isSelected = true
                selectedCards.append(cards[index])
                
                if (selectedCards.count == 3) {
                    if (aSetIsSelected()) {
                        thereIsASet = true
                        score += 5
                    } else {
                        score -= 2
                    }

                    selectedCards.forEach({$0.isSelected = false})
                    selectedCards = [SetCard]()
                }
            }
        }
    }


    func peek() -> Bool {
        handleLeftOverMatchedCards()
        
        if checkForSetInCards() {
            score -= 5
            return true
        } else {
            cards.forEach({ $0.isMisMatched = true })
            score -= 2
            return false
        }
    }
    
    func addThreeCards() {
        handleLeftOverMatchedCards()
        
        if checkForSetInCards() {
            cards.forEach { $0.isSelected = false }
            score -= 2
        }
        for _ in 0..<3 {
            if let card = deck.dealCard() {
                self.cards.append(card)
            }
        }
    }

    
    func checkForSetInCards() -> Bool {
        deselectAllCards()
        
        for i in 0..<cards.count {
            selectedCards = [SetCard]()
            selectedCards.append(cards[i])
            for j in i+1..<cards.count {
                selectedCards.append(cards[j])
                for k in j+1..<cards.count {
                    selectedCards.append(cards[k])
                    if aSetIsSelected() {
                        selectedCards.forEach({
                            $0.isSelected = true
                            $0.isMatched = false
                            $0.isMisMatched = false
                        })
                        selectedCards = [SetCard]()
                        return true
                    }
                    selectedCards[2].isMisMatched = false
                    selectedCards.remove(at: 2)
                    
                }
                selectedCards[1].isMisMatched = false
                selectedCards.remove(at: 1)
            }
            selectedCards[0].isMisMatched = false
            selectedCards.remove(at: 0)
        }
        
        return false
    }

    
    func handleLeftOverMatchedCards() {
        let matchedCards = cards.filter({ $0.isMatched })
        matchedCards.forEach({
            if let index = cards.index(of: $0) {
                if let card = deck.dealCard() {
                    cards[index] = card
                } else {
                    cards.remove(at: index)
                }
            }
        })
        
        cards.forEach({ $0.isMatched = false })
        cards.forEach({ $0.isMisMatched = false })
        thereIsASet = false
    }

    
    func rearrangeCards() {
        for _ in 1...10 {
            for index in cards.indices {
                let randomIndex = Int(arc4random_uniform(UInt32(index)))
                let card = self.cards.remove(at: randomIndex)
                self.cards.append(card)
            }
        }
    }
    
    private func aSetIsSelected() -> Bool {
        var thisIsASet = false
        
        var shapes = Set<SetCard.Shapes>()
        var colors = Set<SetCard.Colors>()
        var shades = Set<SetCard.Shades>()
        var counts = Set<Int>()
        
        selectedCards.forEach({shapes.insert($0.shape)})
        selectedCards.forEach({colors.insert($0.color)})
        selectedCards.forEach({shades.insert($0.shade)})
        selectedCards.forEach({counts.insert($0.count)})
        
        thisIsASet = ((shapes.count == 1 || shapes.count == 3) &&
                      (colors.count == 1 || colors.count == 3) &&
                      (shades.count == 1 || shades.count == 3) &&
                      (counts.count == 1 || counts.count == 3))

        selectedCards.forEach({ $0.isSelected = false })
        
        if thisIsASet {
            selectedCards.forEach({ $0.isMatched = true })
        } else {
            selectedCards.forEach({ $0.isMisMatched = true })
        }
       
        return thisIsASet
    }
    
    
    private func deselectAllCards() {
        cards.forEach({
            $0.isSelected = false
        })
    }
    
    
    init() {
        self.deck = SetCardDeck()
        self.cards = [SetCard]()
        self.score = 0
        
        for _ in 0..<12 {
            if let card = deck.dealCard() {
                self.cards.append(card)
            }
        }
    }
    
}
