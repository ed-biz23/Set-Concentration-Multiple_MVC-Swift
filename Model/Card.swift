//
//  Card.swift
//  Concentration
//
//  Created by Edward Biswas on 9/5/18.
//  Copyright © 2018 Edward Biswas. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int {
        return self.identifier
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
