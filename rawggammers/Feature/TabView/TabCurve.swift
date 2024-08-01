//
//  TabCurve.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import SwiftUI

struct TabCurve: Shape {
    var tabPoint: CGFloat
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
           
            
            let mid = tabPoint
            path.move(to: CGPoint(x: mid - 40, y: rect.height))
            
            let to = CGPoint(x: mid - 40, y: rect.height - 20)
            let control1 = CGPoint(x: mid - 15, y: rect.height)
            let control2 = CGPoint(x: mid - 15, y: 0)
            
            let to1 = CGPoint(x: mid + 40, y: rect.height )
            let control3 = CGPoint(x: mid + 15, y: rect.height)
            let control4 = CGPoint(x: mid + 15, y: 0)
            
            
            path.addCurve(to: to, control1: control1, control2: control2)
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}
