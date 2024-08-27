//
//  LocalFileManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI
import Combine
import Photos

/// `ImageCacheManager` is a class responsible for caching images to the local file system.
/// It provides methods to save images to the cache directory and retrieve them when needed,
/// helping to reduce redundant network requests and improve app performance.
class ImageCacheManager {
    
    // MARK: - Properties
    
    /// An instance of `FileManager` used to handle file operations.
    private let fileManager = FileManager.default
    
    /// The URL of the cache directory where images will be stored.
    private let cacheDirectory: URL
    
    // MARK: - Initializer
    
    /// Initializes an `ImageCacheManager` instance and sets the cache directory to the system's caches directory.
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Methods
    
    /// Retrieves a cached image from the file system using a specified key.
    ///
    /// - Parameter key: A `String` that uniquely identifies the image in the cache.
    /// - Returns: An optional `UIImage` if the image exists in the cache; otherwise, `nil`.
    func getCachedImage(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    /// Caches an image to the file system with a specified key.
    ///
    /// - Parameters:
    ///   - image: The `UIImage` to be cached.
    ///   - key: A `String` that uniquely identifies the image in the cache.
    func cacheImage(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL)
    }
}
