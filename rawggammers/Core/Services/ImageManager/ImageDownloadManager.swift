//
//  ImageDownloadManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import Foundation
import Combine
import SwiftUI

class ImageDownloadManager {
    private var cancellables = Set<AnyCancellable>()
    
    func downloadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in
                UIImage(data: data)
            }
            .catch { _ in Just(nil) }
            .eraseToAnyPublisher()
    }
}
