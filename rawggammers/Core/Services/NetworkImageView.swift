//
//  NetworkImageView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import Foundation

import SwiftUI

struct NetworkImageView: View {
    @StateObject private var imageManager = ImageManager()
    let imageURL: URL
    
    var body: some View {
        Group {
            if let image = imageManager.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageManager.loadImage(from: imageURL)
        }
    }
}
