//
//  UserManager.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage

/// `UserManager` is a singleton class responsible for managing user data within the `rawggammers` application.
/// It interacts with Firebase Firestore and Firebase Storage to handle user creation, data retrieval, and profile updates.
final class UserManager {
    
    // MARK: - Properties
    
    /// Firestore database instance used for accessing the Firestore services.
    private var db = Firestore.firestore()
    
    /// Shared instance of `UserManager` to ensure only one instance is created.
    static let shared = UserManager()
    
    // MARK: - Initializer
    
    /// Private initializer to prevent the creation of multiple instances.
    private init() {}
    
    // MARK: - User Management Methods
    
    /// Creates a new user and stores it in Firestore.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - email: The user's email address.
    ///   - name: The user's name.
    ///   - authType: The type of authentication used (e.g., "email", "google").
    ///   - photoUrl: The URL of the user's profile photo.
    ///   - completion: A completion handler with a `Result` containing either `Void` on success or an `Error` on failure.
    func createNewUser(id: String, email: String, name: String, authType: String, photoUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let user = User(id: id, email: email, name: name, authType: authType, photoUrl: photoUrl, dateCreated: Timestamp(date: Date()))
        
        do {
            try db.collection("users").document(id).setData(from: user, merge: false) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Fetches the current user's data from Firestore.
    ///
    /// - Parameter completion: A completion handler with a `Result` containing either a `User` on success or an `Error` on failure.
    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {
            completion(.failure(FirestoreError.documentNotFoundError))
            return
        }
        
        db.collection("users").document(id).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let user = try? document.data(as: User.self) else {
                completion(.failure(FirestoreError.decodeError))
                return
            }
            
            completion(.success(user))
        }
    }
    
    /// Updates the user's profile name in Firestore.
    ///
    /// - Parameters:
    ///   - name: The new name to update.
    ///   - completion: A completion handler with a `Result` containing either `Void` on success or an `Error` on failure.
    func updateProfileName(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {
            completion(.failure(FirestoreError.documentNotFoundError))
            return
        }
        
        db.collection("users").document(id).updateData(["name": name]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    /// Updates the user's profile image URL in Firestore.
    ///
    /// - Parameters:
    ///   - image: The URL of the new profile image.
    ///   - completion: A completion handler with a `Result` containing either `Void` on success or an `Error` on failure.
    func updateProfileImage(image: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = Auth.auth().currentUser?.uid else {
            completion(.failure(FirestoreError.documentNotFoundError))
            return
        }
        
        db.collection("users").document(id).updateData(["photoUrl": image]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    /// Uploads an image to Firebase Storage and updates the user's profile image URL in Firestore.
    ///
    /// - Parameters:
    ///   - image: The name of the image to upload from the app's assets.
    ///   - completion: A completion handler with a `Result` containing either the image URL as `String` on success or an `Error` on failure.
    func uploadImageToFirebase(image: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Load the image from assets
        guard let image = UIImage(named: image) else {
            print("Failed to load image from assets")
            return
        }
        
        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return
        }
        
        // Get a reference to Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Upload the image data
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload image \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        print("Failed to get download url")
                    } else {
                        // Update the user's profile image URL in Firestore
                        guard let id = Auth.auth().currentUser?.uid else {
                            completion(.failure(FirestoreError.documentNotFoundError))
                            return
                        }
                        
                        self.db.collection("users").document(id).updateData(["photoUrl": url?.absoluteString ?? ""]) { error in
                            if let error = error {
                                completion(.failure(error))
                                print("Failed to update Firestore")
                            } else {
                                completion(.success(url?.absoluteString ?? ""))
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - FirestoreError Enum

/// `FirestoreError` is a custom error enum used for handling specific Firestore errors within the `UserManager`.
enum FirestoreError: Error {
    case decodeError       // Error when failing to decode data from Firestore
    case documentNotFoundError // Error when the requested document is not found
    case unknownError      // Error for any unknown issues
}
