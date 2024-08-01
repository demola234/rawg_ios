//
//  ImageManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//
import Foundation
import Combine
import SwiftUI

class ImageManager: ObservableObject {
    private let cacheManager = ImageCacheManager()
    private let downloadManager = ImageDownloadManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var image: UIImage? = nil
    
    func loadImage(from url: URL) {
        let cacheKey = url.lastPathComponent
        
        if let cachedImage = cacheManager.getCachedImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
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
