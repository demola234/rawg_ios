//
//  SvgHelper.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import SwiftUI
import UIKit
import SVGKit

struct SvgHelper: UIViewRepresentable {
    var svgName: String

    func makeUIView(context: Context) -> SVGView {
        let svgView = SVGView()
        svgView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)   // otherwise the background is black
        svgView.fileName = self.svgName
        svgView.contentMode = .scaleToFill
        return svgView
    }

    func updateUIView(_ uiView: SVGView, context: Context) {

    }
}

#Preview {
    SvgHelper()
}
