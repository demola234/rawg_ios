//
//  UnevenRoundedRectangle.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import Foundation
import SwiftUI

/// A custom `Shape` that represents a rectangle with uneven rounded corners at the bottom.
struct UnevenRoundedRectangle: Shape {
    
    // MARK: - Properties
    
    /// The radius of the bottom leading corner.
    var bottomLeadingRadius: CGFloat
    
    /// The radius of the bottom trailing corner.
    var bottomTrailingRadius: CGFloat
    
    // MARK: - Methods
    
    /// Creates the path for the shape based on the given rectangle.
    ///
    /// - Parameter rect: The rectangle in which to draw the shape.
    /// - Returns: A `Path` object representing the uneven rounded rectangle.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at the top-left corner of the rectangle
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        
        // Draw the top edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Draw the top-right corner and right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomTrailingRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - bottomTrailingRadius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        
        // Draw the bottom edge
        path.addLine(to: CGPoint(x: rect.minX + bottomLeadingRadius, y: rect.maxY))
        
        // Draw the bottom-left corner and left edge
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - bottomLeadingRadius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        
        // Close the path back to the top-left corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}
