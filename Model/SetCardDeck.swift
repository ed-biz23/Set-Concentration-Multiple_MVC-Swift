//
//  SetCardDeck.swift
//  Homework 2
//
//  Created by Sameh Fakhouri on 10/5/18.
//  Copyright © 2018 CUNY Lehman College. All rights reserved.
//

import Foundation

struct SetCardDeck {
    
    private var deck = [SetCard]()
 
    
    mutating func dealCard() -> SetCard? {
        if self.deck.count > 0 {
            let card = self.deck.remove(at: 0)
            return card
        } else {
            return nil
        }
    }

    
    func count() -> Int {
        return self.deck.count
    }
    
    
    func isEmpty() -> Bool {
        if self.deck.count == 0 {
            return true
        }
        return false
    }
 
    
    init() {
        for color in SetCard.Colors.all {
            for shape in SetCard.Shapes.all {
                for shade in SetCard.Shades.all {
                    for count in 1...3 {
                        self.deck += [SetCard(shape: shape,
                                              shade: shade,
                                              color: color,
                                              count: count)]
                    }
                }
            }
        }
        
        for _ in 1...10 {
            for index in deck.indices {
                let randomIndex = Int(arc4random_uniform(UInt32(index)))
                let card = self.deck.remove(at: randomIndex)
                self.deck.append(card)
            }
        }
    }
}
