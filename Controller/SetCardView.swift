//
//  SetCardViewTest.swift
//  Homework 3
//
//  Created by Edward Biswas on 11/6/18.
//  Copyright © 2018 Sameh A Fakhouri. All rights reserved.
//

import UIKit

@IBDesignable
/// The view responsible for displaying a single card.
class SetCardView: UIView {

    /// The symbol shape (diamong, squiggle or oval) for this card view.
    var symbolShape: SetCard.Shapes = SetCard.Shapes.squiggle {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The symbol color (red, green or purple) for this card view.
    var color: SetCard.Colors = SetCard.Colors.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The symbol shading (solid, striped or open) for this card view.
    var symbolShading: SetCard.Shades = SetCard.Shades.striped {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The number of symbols (one, two or three) for this card view.
    var numberOfSymbols = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isSelected = false { didSet { setNeedsDisplay() } }
    var isMatched = false { didSet { setNeedsDisplay() } }
    var isMisMatched = false { didSet { setNeedsDisplay() } }
    
    /// The path containing all shapes of this view.
    var path: UIBezierPath?
    
    /// The rect in which each path is drawn.
    private var drawableRect: CGRect {
        let drawableWidth = frame.size.width * 0.80
        let drawableHeight = frame.size.height * 0.90
        
        return CGRect(x: frame.size.width * 0.1,
                      y: frame.size.height * 0.05,
                      width: drawableWidth,
                      height: drawableHeight)
    }
    
    private var shapeHorizontalMargin: CGFloat {
        return drawableRect.width * 0.05
    }
    
    private var shapeVerticalMargin: CGFloat {
        return drawableRect.height * 0.05 + drawableRect.origin.y
    }
    
    private var shapeWidth: CGFloat {
        return (drawableRect.width - (2 * shapeHorizontalMargin)) / 3
    }
    
    private var shapeHeight: CGFloat {
        return drawableRect.size.height * 0.9
    }
    
    private var drawableCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    private var colorForPath: UIColor {
        switch color {
        case .green:
            return UIColor.green
        case .red:
            return UIColor.red
        case .purple:
            return UIColor.purple
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: bounds,
                                       cornerRadius: 16)
        roundedRect.addClip()
        
        if isSelected {
            roundedRect.lineWidth = 5.0
            UIColor.purple.setStroke()
        } else if isMatched {
            roundedRect.lineWidth = 5.0
            UIColor.green.setStroke()
        } else if isMisMatched {
            roundedRect.lineWidth = 5.0
            UIColor.red.setStroke()
        } else {
            roundedRect.lineWidth = 5.0
            UIColor.white.setStroke()
        }
        
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        roundedRect.fill()
        roundedRect.stroke()
        
        switch (self.symbolShape) {
        case .squiggle:
            drawSquiggles()
            
        case .diamond:
            drawDiamonds()
            
        case .oval:
            drawOvals()
        }
        
        path!.lineCapStyle = .round
        
        switch symbolShading {
        case .filled:
            colorForPath.setFill()
            path!.fill()
            
        case .outlined:
            colorForPath.setStroke()
            path!.lineWidth = 1 // TODO: Calculate the line width
            path!.stroke()
            
        case .striped:
            path!.lineWidth = 0.01 * frame.size.width
            colorForPath.setStroke()
            path!.stroke()
            path!.addClip()
            
            var currentX: CGFloat = 0
            
            let stripedPath = UIBezierPath()
            stripedPath.lineWidth = 0.005 * frame.size.width
            
            while currentX < frame.size.width {
                stripedPath.move(to: CGPoint(x: currentX, y: 0))
                stripedPath.addLine(to: CGPoint(x: currentX, y: frame.size.height))
                currentX += 0.03 * frame.size.width
            }
            
            colorForPath.setStroke()
            stripedPath.stroke()
            
            break
        }
    }
    
    /// Draws the squiggles to the drawable rect.
    private func drawSquiggles() {
        let path = UIBezierPath()
        let allSquigglesWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allSquigglesWidth) / 2
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            let currentShapeY = shapeVerticalMargin
            let curveXOffset = shapeWidth * 0.35
            
            path.move(to: CGPoint(x: currentShapeX, y: currentShapeY))
            
            path.addCurve(to: CGPoint(x: currentShapeX, y: currentShapeY + shapeHeight),
                          controlPoint1: CGPoint(x: currentShapeX + curveXOffset, y: currentShapeY + shapeHeight / 3),
                          controlPoint2: CGPoint(x: currentShapeX - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2))
            
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY + shapeHeight))
            
            path.addCurve(to: CGPoint(x: currentShapeX + shapeWidth, y: currentShapeY),
                          controlPoint1: CGPoint(x: currentShapeX + shapeWidth - curveXOffset, y: currentShapeY + (shapeHeight / 3) * 2),
                          controlPoint2: CGPoint(x: currentShapeX + shapeWidth + curveXOffset, y: currentShapeY + shapeHeight / 3))
            
            path.addLine(to: CGPoint(x: currentShapeX, y: currentShapeY))
        }
        
        self.path = path
    }
    
    /// Draws the ovals to the drawable rect.
    private func drawOvals() {
        let allOvalsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allOvalsWidth) / 2
        path = UIBezierPath()
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            
            path!.append(UIBezierPath(roundedRect: CGRect(x: currentShapeX,
                                                          y: shapeVerticalMargin,
                                                          width: shapeWidth,
                                                          height: shapeHeight),
                                      cornerRadius: shapeWidth))
        }
    }
    
    /// Draws the diamonds to the drawable rect.
    private func drawDiamonds() {
        let allDiamondsWidth = CGFloat(numberOfSymbols) * shapeWidth + CGFloat(numberOfSymbols - 1) * shapeHorizontalMargin
        let beginX = (frame.size.width - allDiamondsWidth) / 2
        
        let path = UIBezierPath()
        
        for i in 0..<numberOfSymbols {
            let currentShapeX = beginX + (shapeWidth * CGFloat(i)) + (CGFloat(i) * shapeHorizontalMargin)
            
            path.move(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
            path.addLine(to: CGPoint(x: currentShapeX, y: drawableCenter.y))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin + shapeHeight))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth, y: drawableCenter.y))
            path.addLine(to: CGPoint(x: currentShapeX + shapeWidth / 2, y: shapeVerticalMargin))
        }
        
        self.path = path
    }
    
}
