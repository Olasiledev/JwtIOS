//
//  UserManager.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile & Ripudaman Singh on 2024-04-04.
//

import Foundation
import UIKit

//MARK: - SignUP USER RESPONSE
struct UserResponse: Decodable {
    let _id: ObjectId
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let __v: Int
}

struct ObjectId: Decodable {
    let oid: String
}

//MARK: - LOGIN USER RESPONSE
struct LoginResponse: Decodable {
    let token: String
    let user: LoginUserResponse
}

struct LoginUserResponse: Decodable {
    let _id: String
    let firstName: String
    let lastName: String
    let email: String
    let __v: Int
}


//MARK: - METHODS MANAGER
struct UserManager {
    //SERVER RESPONSE
    enum NetworkError: Error {
        case invalidEndpoint
        case invalidData
        case noData
    }
    
    //MARK: - SIGN UP USER
    static func createUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://jwtassingment.onrender.com/api/users/register") else {
            print("Wrong URL")
            return
        }
        //URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //USER DATA
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "password": password
        ]
        
        do {
            //Sending user data
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    print("Response from server-> \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.success(()))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    
    //MARK: - LOGIN USER
    static func loginUser(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let loginURL = URL(string: "https://jwtassingment.onrender.com/api/users/login") else {
            completion(.failure(NetworkError.invalidEndpoint))
            return
        }
        //URL Request
        var loginRequest = URLRequest(url: loginURL)
        loginRequest.httpMethod = "POST"
        loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //Login parameters
        let loginParams: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        //Request body
        print("Request body-> \(loginParams)")
        
        // Converting parameters to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginParams) else {
            completion(.failure(NetworkError.invalidData))
            return
        }
        
        loginRequest.httpBody = jsonData
        
        URLSession.shared.dataTask(with: loginRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code-> \(httpResponse.statusCode)")
            }
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("Server Response-> \(responseString)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let loginResponse = try decoder.decode(LoginResponse.self, from: responseData)
                UserDefaults.standard.set(loginResponse.token, forKey: "userToken")
                UserDefaults.standard.set(loginResponse.user.firstName, forKey: "firstName")
                UserDefaults.standard.set(loginResponse.user.lastName, forKey: "lastName")
                
                completion(.success(loginResponse))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
