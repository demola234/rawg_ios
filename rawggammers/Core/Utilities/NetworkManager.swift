//
//  NetworkManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

/// A utility class for performing network requests using Combine.
class NetworkManager {
    
    // MARK: - GET Request
    
    /// Performs a GET request.
    ///
    /// - Parameter url: The `URLRequest` to be executed.
    /// - Returns: An `AnyPublisher` that emits the data on success or a `NetworkError` on failure.
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
    
    /// Performs a POST request.
    ///
    /// - Parameters:
    ///   - url: The `URLRequest` to be executed.
    ///   - body: The data to be sent in the request body.
    /// - Returns: An `AnyPublisher` that emits the data on success or a `NetworkError` on failure.
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
    
    /// Performs a PUT request.
    ///
    /// - Parameters:
    ///   - url: The `URLRequest` to be executed.
    ///   - body: The data to be sent in the request body.
    /// - Returns: An `AnyPublisher` that emits the data on success or a `NetworkError` on failure.
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
    
    /// Performs a PATCH request.
    ///
    /// - Parameters:
    ///   - url: The `URLRequest` to be executed.
    ///   - body: The data to be sent in the request body.
    /// - Returns: An `AnyPublisher` that emits the data on success or a `NetworkError` on failure.
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
    
    /// Uploads a file.
    ///
    /// - Parameters:
    ///   - url: The `URLRequest` for the upload.
    ///   - fileURL: The local file URL to be uploaded.
    /// - Returns: An `AnyPublisher` that emits the data on success or a `NetworkError` on failure.
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
    
    /// Uploads multiple files.
    ///
    /// - Parameters:
    ///   - url: The `URLRequest` for the upload.
    ///   - files: An array of local file URLs to be uploaded.
    /// - Returns: An `AnyPublisher` that emits the data on success or a `NetworkError` on failure.
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
    
    /// Handles the URL response.
    ///
    /// - Parameters:
    ///   - output: The data returned from the request.
    ///   - response: The URL response returned from the request.
    /// - Throws: `NetworkError.invalidResponse` if the response is not an `HTTPURLResponse` or `NetworkError.statusCode` if the status code is not 200.
    /// - Returns: The data if the response is valid and status code is 200.
    private static func handleUrlResponse(output: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard response.statusCode == 200 else {
            throw NetworkError.statusCode(response.statusCode)
        }
        
        return output
    }
    
    /// Creates a multipart form-data body with a single file.
    ///
    /// - Parameters:
    ///   - fileURL: The local file URL.
    ///   - boundary: The boundary string used to separate parts of the form-data.
    /// - Returns: The data for the body of the request, or `nil` if the file could not be read.
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
    
    /// Creates a multipart form-data body with multiple files.
    ///
    /// - Parameters:
    ///   - files: An array of local file URLs.
    ///   - boundary: The boundary string used to separate parts of the form-data.
    /// - Returns: The data for the body of the request, or `nil` if any file could not be read.
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
