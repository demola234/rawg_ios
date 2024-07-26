//
//  NetworkManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

class NetworkManager {
    
    // MARK: - GET Request
    static func getRequest(url: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap({ try handleUrlResponse(output: $0.data, response: $0.response) })
            .mapError { $0 as? NetworkError ?? NetworkError.invalidResponse }
            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    // MARK: - POST Request
    static func postRequest(url: URLRequest, body: Data) -> AnyPublisher<Data, NetworkError> {
        var request = url
        request.httpMethod = "POST"
        request.httpBody = body
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap({ try handleUrlResponse(output: $0.data, response: $0.response) })
            .mapError { $0 as? NetworkError ?? NetworkError.invalidResponse }
            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    // MARK: - PUT Request
    static func putRequest(url: URLRequest, body: Data) -> AnyPublisher<Data, NetworkError> {
        var request = url
        request.httpMethod = "PUT"
        request.httpBody = body
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap({ try handleUrlResponse(output: $0.data, response: $0.response) })
            .mapError { $0 as? NetworkError ?? NetworkError.invalidResponse }
            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    // MARK: - PATCH Request
    static func patchRequest(url: URLRequest, body: Data) -> AnyPublisher<Data, NetworkError> {
        var request = url
        request.httpMethod = "PATCH"
        request.httpBody = body
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap({ try handleUrlResponse(output: $0.data, response: $0.response) })
            .mapError { $0 as? NetworkError ?? NetworkError.invalidResponse }
            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    // MARK: - File Upload
    static func uploadFile(url: URLRequest, fileURL: URL) -> AnyPublisher<Data, NetworkError> {
        var request = url
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let body = createBodyWithFile(fileURL: fileURL, boundary: boundary) else {
            return Fail(error: NetworkError.fileNotFound).eraseToAnyPublisher()
        }
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap({ try handleUrlResponse(output: $0.data, response: $0.response) })
            .mapError { $0 as? NetworkError ?? NetworkError.invalidResponse }
            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Multiple File Upload
    static func uploadMultipleFiles(url: URLRequest, files: [URL]) -> AnyPublisher<Data, NetworkError> {
        var request = url
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let body = createBodyWithFiles(files: files, boundary: boundary) else {
            return Fail(error: NetworkError.fileNotFound).eraseToAnyPublisher()
        }
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap({ try handleUrlResponse(output: $0.data, response: $0.response) })
            .mapError { $0 as? NetworkError ?? NetworkError.invalidResponse }
            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helper Methods
    private static func handleUrlResponse(output: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard response.statusCode == 200 else {
            throw NetworkError.statusCode(response.statusCode)
        }
        
        return output
    }
    
    private static func createBodyWithFile(fileURL: URL, boundary: String) -> Data? {
        var body = Data()
        
        let filename = fileURL.lastPathComponent
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        let mimetype = "application/octet-stream"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    private static func createBodyWithFiles(files: [URL], boundary: String) -> Data? {
        var body = Data()
        
        for file in files {
            let filename = file.lastPathComponent
            guard let data = try? Data(contentsOf: file) else {
                return nil
            }
            let mimetype = "application/octet-stream"
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
