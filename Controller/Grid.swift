//
//  SetGrid.swift
//  Set
//
//  Created by jamfly on 2018/1/12.
//  Copyright © 2018年 jamfly. All rights reserved.
//
import UIKit

struct Grid {
    
    private var bounds: CGRect { didSet { calculateGrid() } }
    private var numberOfFrames: Int  { didSet { calculateGrid() } }
    static var idealAspectRatio: CGFloat = 0.7
    //
    // You initialize the Grid class by specifying:
    //
    // for bounds: CGRect
    //          This is the bounds of the superview that will contain all your subviews
    //
    // withNoOfFrames: Int
    //          This is the number of subviews you are looking to layout in the superview
    //
    // forIdeal aspectRatio: CGFloat
    //          This is the aspect ratio that you want your subviews to have
    //
    init(for bounds: CGRect, withNoOfFrames: Int, forIdeal aspectRatio: CGFloat = Grid.idealAspectRatio) {
        self.bounds = bounds
        self.numberOfFrames = withNoOfFrames
        Grid.idealAspectRatio = aspectRatio
        calculateGrid()
    }
    
    //
    // This is the method that allows you to access the bounds of each subview.
    // You will access the bounds of each of
    // your subviews using an index.
    //
    // This method will return a CGRect describing the bounds of the subview at the specified index
    //
    //     grid[0], grid[1], ..., grid[n]
    //
    subscript(index: Int) -> CGRect? {
        return index < cellFrames.count ? cellFrames[index] : nil
    }
    
    private struct GridDimensions: Comparable {
        static func <(lhs: Grid.GridDimensions, rhs: Grid.GridDimensions) -> Bool {
            return lhs.isCloserToIdeal(aspectRatio: rhs.aspectRatio)
        }
        
        static func ==(lhs: Grid.GridDimensions, rhs: Grid.GridDimensions) -> Bool {
            return lhs.cols == rhs.cols && lhs.rows == rhs.rows
        }
        
        var cols: Int
        var rows: Int
        var frameSize: CGSize
        var aspectRatio: CGFloat {
            return frameSize.width/frameSize.height
        }
        
        func isCloserToIdeal(aspectRatio: CGFloat) -> Bool {
            return (Grid.idealAspectRatio - aspectRatio).abs < (Grid.idealAspectRatio - self.aspectRatio).abs
        }
    }
    
    private var bestGridDimensions: GridDimensions?
    private mutating func calculateGridDimensions() {
        for cols in 1...numberOfFrames {
            let rows = numberOfFrames % cols == 0 ? numberOfFrames / cols: numberOfFrames/cols + 1
            let calculatedframeDimension = GridDimensions(
                cols: cols,
                rows: rows,
                frameSize: CGSize(width: bounds.width / CGFloat(cols), height: bounds.height / CGFloat(rows))
            )
            
            if let bestFrameDimension = bestGridDimensions, bestFrameDimension > calculatedframeDimension {
                return
            } else {
                self.bestGridDimensions = calculatedframeDimension
            }
        }
        return
    }
    
    private var cellFrames: [CGRect] = []
    private mutating func calculateGrid() {
        var grid = [CGRect]()
        calculateGridDimensions()
        guard let bestGridDimensions = bestGridDimensions else {
            grid = []
            return
        }
        for row in 0..<bestGridDimensions.rows {
            for col in 0..<bestGridDimensions.cols {
                let origin = CGPoint(x: CGFloat(col) * bestGridDimensions.frameSize.width, y: CGFloat(row) * bestGridDimensions.frameSize.height)
                let rect = CGRect(origin: origin, size: bestGridDimensions.frameSize)
                grid.append(rect)
            }
        }
        self.cellFrames = grid
    }
}

extension CGFloat {
    var abs: CGFloat {
        return self<0 ? -self: self
    }
}
