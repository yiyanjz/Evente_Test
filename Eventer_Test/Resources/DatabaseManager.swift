//
//  DatabaseManager.swift
//  Eventer_Test
//
//  Created by Justin Zhang on 8/7/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    // setup database
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
        
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        // query the database once (singleevent)
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else {
                // if email not found in query
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// insert new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastname,
        ])
    }
}

struct ChatAppUser {
    let firstname: String
    let lastname: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
//    let profilePictureUrl: String
}
