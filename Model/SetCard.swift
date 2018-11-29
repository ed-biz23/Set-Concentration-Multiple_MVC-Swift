//
//  SetCard.swift
//  Homework 2
//
//  Created by Sameh Fakhouri on 10/5/18.
//  Copyright © 2018 CUNY Lehman College. All rights reserved.
//

import Foundation
import UIKit

class SetCard : Equatable {
    
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        return (lhs.shape == rhs.shape) && (lhs.color == rhs.color) && (lhs.shade == rhs.shade) && (lhs.count == rhs.count)
    }
    
    
    var shape: Shapes
    var shade: Shades
    var color: Colors
    var count: Int
    var isSelected = false
    var isMatched = false
    var isMisMatched = false
    
    
    enum Shapes {
        case diamond
        case oval
        case squiggle
        
        static var all = [Shapes.diamond, .oval, .squiggle]
    }
    
    enum Shades {
        case outlined
        case striped
        case filled
        
        static var all = [Shades.outlined, .striped, .filled]
    }
    
    enum Colors {
        case green
        case red
        case purple
        
        static var all = [Colors.green, .red, .purple]
    }
    
    init(shape: Shapes, shade: Shades, color: Colors, count: Int) {
        self.shape = shape
        self.shade = shade
        self.color = color
        self.count = count
        self.isSelected = false
        self.isMatched = false
        self.isMatched = false
    }
}
