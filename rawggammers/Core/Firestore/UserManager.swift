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

final class UserManager {
    private var db = Firestore.firestore()
    
    static let shared = UserManager()
    
    private init() {}
    
    // Create a new user and store it in Firestore
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
    
    // Fetch user data from Firestore
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
    
    func updateProfileName (name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
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
    
    func updateProfileImage (image: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
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
    
    func uploadImageToFirebase(image: String, completion: @escaping (Result<String, Error>) -> Void) {
        //        Load the image from assets
        guard let image = UIImage(named: image) else {
            print("Failed to load image from assets")
            return
        }
        
        //        Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to data")
            return
        }
        
        //        Get a reference to Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        //        Upload the image data
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
                        //        upload url to firestore
                        guard let id = Auth.auth().currentUser?.uid else {
                            completion(.failure(FirestoreError.documentNotFoundError))
                            return
                        }
                        
                        self.db.collection("users").document(id).updateData(["photoUrl": url?.absoluteString ?? ""]) { error in
                            if let error = error {
                                completion(.failure(error))
                                print("Failed to update firestore")
                            } else {
                                completion(.success(url?.absoluteString ?? ""))
                            }
                            completion(.success(url?.absoluteString ?? ""))
                        }
                    }
                }
            }
        }
        
    }
}

// Define User struct conforming to Codable for easy serialization/deserialization
class User: Codable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var authType: String
    var photoUrl: String
    var dateCreated: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case authType
        case photoUrl
        case dateCreated
    }
    
    init(id: String, email: String, name: String, authType: String, photoUrl: String, dateCreated: Timestamp) {
        self.id = id
        self.email = email
        self.name = name
        self.authType = authType
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
    }
}

// Custom error enum for handling Firestore errors
enum FirestoreError: Error {
    case decodeError
    case documentNotFoundError
    case unknownError
}
