//
//  APIManager.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import KeychainSwift
import JWTDecode
import os
class APIManager{
    static let shared = APIManager()
    private let baseURL = "http://127.0.0.1:8000/"
    let keychain = KeychainSwift()
    
    func registerUser(email:String, username:String,password:String,complection:@escaping(Result<[String:Any],Error>)->Void){
        let url = URL(string:"\(baseURL)api/v1/users/register")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        let parameters: [String:Any]=[
            "email": email,
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request){data,response,error in
            guard error == nil else{
                complection(.failure(error!))
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:data!, options: [])
                guard let jsonObject = jsonResponse as? [String:Any],
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 201 else {
                    complection(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }
                
                if let bearerToken = jsonObject["bearerToken"] as? String {
                    self.keychain.set(bearerToken, forKey: "bearerToken")
                    let return_obj = self.decodeToken(bearerToken)
                    complection(.success(return_obj!))
                }
                
            } catch {
                complection(.failure(error))
            }
        }.resume()
    }
    func loginUser(username: String?, password: String?, completion: @escaping (Result<[String:Any],Error>) -> Void) {
        let url = URL(string: "\(baseURL)api/v1/users/login")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = keychain.get("bearerToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if let username = username, let password = password {
            let parameters: [String:Any] = [
                "username": username,
                "password": password
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No credentials or token provided"])))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonObject = jsonResponse as? [String:Any],
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])))
                    self.keychain.delete("bearerToken")
                    return
                }
                
                if let bearerToken = jsonObject["bearerToken"] as? String {
                    self.keychain.set(bearerToken, forKey: "bearerToken")
                    let return_obj = self.decodeToken(bearerToken)
                    completion(.success(return_obj!))
                } else {
                    // Handle case when token is not valid, clear saved token and go back to login
                    self.keychain.delete("bearerToken")
                    // Navigate back to login screen
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func createGrup(groupName:String?, completion:@escaping(Result<[String:Any],Error>)->Void){
        let url = URL(string: "\(baseURL)api/v1/userGroup/create_group")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let decodedToken = decodeToken(keychain.get("bearerToken")!) {
            let parameter:[String:Any]=[
                "name": groupName!,
                "owner_id":decodedToken["id"] as Any
            ]
            request.httpBody = try?JSONSerialization.data(withJSONObject: parameter)
            
            URLSession.shared.dataTask(with: request){data,response,error in
                guard error == nil else{
                    completion(.failure(error!))
                    return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:data!, options: [])
                    guard let jsonObject = jsonResponse as? [String:Any],
                          let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 201 else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                        return
                    }
                    completion(.success(jsonObject))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
            
        }
        
    }
    func getGrup(completion:@escaping(Result<[[String:Any]],Error>)->Void){
        
        
        if let decodedToken = decodeToken(keychain.get("bearerToken")!) {
            let user_id = decodedToken["id"] as! String
            let url = URL(string: "\(baseURL)api/v1/userGroup/get_groups/\(user_id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request){data,response,error in
                guard error == nil else{
                    completion(.failure(error!))
                    return
                }
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:data!, options: [])
                    guard let jsonObject = jsonResponse as? [[String:Any]],
                          let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                        return
                    }
                    completion(.success(jsonObject))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
            
        }
        
    }
    @available(iOS 15.0, *)
    func getUserGrup(groupId : String ) async throws -> [String: Any]{
        if let decodedToken = decodeToken(keychain.get("bearerToken")!) {
            let url = URL(string: "\(baseURL)api/v1/userGroup/get_user_group/\(groupId)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            let jsonResponse = try JSONSerialization.jsonObject(with:data, options: [])
            guard let jsonObject = jsonResponse as? [String:Any],
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "", code: -1, userInfo: nil)
            }
            return jsonObject
        } else {
            
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No decoded token found"])
        }
    }
    @available(iOS 15.0, *)
    func addUserToGroup(email: String,groupId:String ) async throws -> [String: Any]{
        if let decodedToken = decodeToken(keychain.get("bearerToken")!) {
            let url = URL(string: "\(baseURL)api/v1/userGroup/add_user_to_group")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let parameters = [
                "email": email,
                "group_id": groupId
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            let jsonResponse = try JSONSerialization.jsonObject(with:data, options: [])
            guard let jsonObject = jsonResponse as? [String:Any],
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "", code: -1, userInfo: nil)
            }
            return jsonObject
        } else {
            
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No decoded token found"])
        }
    }
    
    
    func decodeToken(_ token: String) -> [String: Any]? {
        do {
            let jwt = try decode(jwt: token)
            let body = jwt.body // body jest typu [String: Any]
            return body
        } catch {
            print("Error decoding JWT: \(error)")
            return nil
        }
    }
    
}
