//
//  LocalFileManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI
import Combine
import Photos

class ImageCacheManager {
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    func getCachedImage(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL)
    }
}
