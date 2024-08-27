//
//  NetworkImageView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import Foundation
import SwiftUI

/// `NetworkImageView` is a SwiftUI view that asynchronously loads and displays an image from a given URL.
/// It uses an `ImageManager` to handle the image downloading process and displays a placeholder
/// `ProgressView` while the image is being fetched.
///
/// The view is designed to be reusable and efficient, making it a suitable component for any
/// scenario where images need to be loaded from the network.
struct NetworkImageView: View {
    
    // MARK: - Properties
    
    /// The URL of the image to be loaded and displayed.
    let imageURL: URL
    
    /// The `ImageManager` instance responsible for managing the image download.
    /// It's observed as a `@StateObject` to ensure the image data is preserved
    /// and updated as the state changes.
    @StateObject private var imageManager = ImageManager()
    
    // MARK: - Body
    
    var body: some View {
        Group {
            // Display the image if it's successfully loaded, otherwise show a progress indicator.
            if let image = imageManager.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            // Trigger the image loading process when the view appears.
            imageManager.loadImage(from: imageURL)
        }
    }
}
