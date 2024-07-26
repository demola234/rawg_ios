//
//  SvgHelper.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI
import SVGKit

struct SVGView: UIViewRepresentable {
    let svgName: String

    func makeUIView(context: Context) -> SVGKFastImageView {
        let svgImageView = SVGKFastImageView(svgkImage: SVGKImage(named: svgName))
        svgImageView?.contentMode = .scaleAspectFit
        return svgImageView ?? SVGKFastImageView()
    }

    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        // This function can be used to update the view if needed
    }
}
