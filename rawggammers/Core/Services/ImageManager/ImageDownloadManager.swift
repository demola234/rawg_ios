//
//  ImageDownloadManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import Foundation
import Combine
import SwiftUI

/// `ImageDownloadManager` is a class responsible for downloading images from a given URL.
/// It uses Combine's `Publisher` to handle the asynchronous download and provides a stream
/// of `UIImage` objects to subscribers. The manager is designed to handle image downloads
/// efficiently and allows easy integration with SwiftUI views.
class ImageDownloadManager {
    
    // MARK: - Properties
    
    /// A set of `AnyCancellable` objects that store the active subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
    /// Downloads an image from a specified URL and returns a publisher that emits the downloaded image.
    ///
    /// - Parameter url: The URL of the image to be downloaded.
    /// - Returns: An `AnyPublisher<UIImage?, Never>` that emits the downloaded `UIImage` or `nil` if the download fails.
    ///
    /// This method utilizes `URLSession`'s `dataTaskPublisher` to asynchronously fetch the image data
    /// and convert it into a `UIImage`. The publisher will emit the image once the download completes,
    /// or `nil` if an error occurs during the download process.
    func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in
                UIImage(data: data)
            }
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }
}
