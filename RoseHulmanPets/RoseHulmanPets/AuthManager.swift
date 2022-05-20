//
//  AuthManager.swift
//  MovieQuotes
//
//  Created by Maddie Sorensen on 4/7/22.
//

import Foundation
import Firebase


class AuthManager{
    
    static let shared = AuthManager()
    
  
    private init(){
       
    }
    
    var currentUser: User?{
        Auth.auth().currentUser
    }
    
    
    var isSignedIn: Bool{
        get{
            return currentUser != nil
        }
    }
    
    func addLoginObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle{
        return Auth.auth().addStateDidChangeListener { auth, user in
            if(user != nil){
                callback()
            }
        }
    }
//
    
     func addLogoutObserver(callback: @escaping (()->Void)) -> AuthStateDidChangeListenerHandle{
         return Auth.auth().addStateDidChangeListener { auth, user in
             if(user == nil){
                 callback()
             }
         }
}
//     }
        
    func removeObserver(_ authDidChangeHandle: AuthStateDidChangeListenerHandle?){
        if let authHandle = authDidChangeHandle{
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    func signInNewEmailPasswordUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("there was an error creating the user: \(error)")
            }
            print("User Created")
        }
        
    }
    
    func loginExistingEmailPasswordUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("there was an error creating the user: \(error)")
            }
            print("User Created")
        }
    }
    
    
    func signInAnonymously(){
        Auth.auth().signInAnonymously(){authResult, error in
            if let error = error{
                print("There was an error with anonymous sign in: \(error)")
                return
            }
            print("Anonymous sign in complete.")
        }
        
    }
    
    func signInWithRoseFireToken(_ rosefireToken: String){
        Auth.auth().signIn(withCustomToken: rosefireToken) { authResult, error in
            if let error=error{
                print("Firebase sign in error! \(error)")
                return
            }
            print("The user is now signed in")
        }
    }
    
    func signInWithGoogleCredential(_ googleCredential: AuthCredential){
        Auth.auth().signIn(with: googleCredential)
        
    }
    func signOut(){
        do{
       try  Auth.auth().signOut()
        }catch{
            print("SignOut failed: \(error)")
        }
    }
    
}
