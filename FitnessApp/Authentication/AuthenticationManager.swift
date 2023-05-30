//
//  AuthenticationManager.swift
//  FitnessApp
//
//  Created by Toby Rutherford on 24/5/2023.
//

import Foundation
import FirebaseAuth

struct AuthenticationResultModel {
    let userId: String;
    let email:String?;
    
    init(user: User) {
        self.userId = user.uid;
        self.email = user.email;
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthenticationResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse);
        }
        return AuthenticationResultModel(user: user);
    }
    
    func getUser(email: String, password: String) async throws -> AuthenticationResultModel {
        let authenticationResult = try await Auth.auth().signIn(withEmail: email, password: password);
        return AuthenticationResultModel(user: authenticationResult.user);
    }
    
    func createUser(email: String, password: String) async throws -> AuthenticationResultModel {
        let authenticationResult = try await Auth.auth().createUser(
            withEmail: email,
            password: password);
        return AuthenticationResultModel(user: authenticationResult.user);
    }
    
    func signOut() throws {
        try Auth.auth().signOut();
    }
}
