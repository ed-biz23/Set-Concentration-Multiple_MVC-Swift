//
//  SetGameView.swift
//  Homework 3
//
//  Created by Sameh Fakhouri on 10/25/18.
//  Copyright © 2018 Sameh A Fakhouri. All rights reserved.
//

import UIKit

class SetGameView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let setGrid = Grid(for: self.bounds,
                           withNoOfFrames: self.subviews.count)

        for index in self.subviews.indices {
            if var frame = setGrid[index] {
                frame.size.width -= 5
                frame.size.height -= 5
                self.subviews[index].frame = frame
            }
        }
    }
}
