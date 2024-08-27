//
//  ImageManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import Foundation
import Combine
import SwiftUI

/// `ImageManager` is an `ObservableObject` that handles the loading, caching, and management
/// of images in the app. It combines local caching with online image downloading, ensuring
/// efficient and optimized image handling within a SwiftUI environment.
class ImageManager: ObservableObject {
    
    // MARK: - Properties
    
    /// An instance of `ImageCacheManager` that handles caching images locally.
    private let cacheManager = ImageCacheManager()
    
    /// An instance of `ImageDownloadManager` that handles downloading images from the internet.
    private let downloadManager = ImageDownloadManager()
    
    /// A set of `AnyCancellable` objects to store the subscriptions for Combine publishers.
    private var cancellables = Set<AnyCancellable>()
    
    /// A `Published` property that stores the currently loaded image.
    /// Views observing `ImageManager` will update automatically when this value changes.
    @Published var image: UIImage? = nil
    
    // MARK: - Methods
    
    /// Loads an image from a given URL, utilizing the cache if available, or downloading it if not.
    ///
    /// - Parameter url: The URL of the image to be loaded.
    ///
    /// This method first checks if the image is available in the local cache.
    /// If a cached image is found, it is immediately set to the `image` property.
    /// Otherwise, it downloads the image from the provided URL, caches it locally,
    /// and then updates the `image` property. The downloading and updating process
    /// is handled asynchronously and updates the UI on the main thread.
    func loadImage(from url: URL) {
        let cacheKey = url.lastPathComponent
        
        // Check if the image is already cached
        if let cachedImage = cacheManager.getCachedImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        // Download the image if not cached
        downloadManager.downloadImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                if let image = downloadedImage {
                    self?.image = image
                    self?.cacheManager.cacheImage(image, forKey: cacheKey)
                }
            }
            .store(in: &cancellables)
    }
}
