//
//  Network Manager.swift
//  Newproject
//
//  Created by Yulya on 28.03.2023.
//

import Foundation

class NetworkManager {
    
    static let networkItem = NetworkManager()
    
    private var token: String?
    
    
    func setToken(token: String) {
        self.token = token
    }
    
    func setGetTokenFromUserDefaults() {
        if UserDefaults.standard.string(forKey: "token") != nil {
            setToken(token: UserDefaults.standard.string(forKey: "token")!)
        } else {
            return
        }
    }
//
    
    func getSession(completion: @escaping (Tasks) -> Void) {
        
        guard let token = self.token else { return }
        
        var allParams: [String : Any] = ["token": token]
        
        let req: RequestManager = .get
        guard let url = URL(string: req.url + "?token=" + token) else {
            return
        }
        var request = URLRequest(url: url)
        print(request)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: allParams, options: .prettyPrinted) else {
            return
        }
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        print(allParams)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = req.method
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(12345678, response, data?.description)
            }
            if let parsData = data {
                guard let cases = try?
                        JSONDecoder().decode(Tasks.self, from: parsData) else { return }
                print(12345678, parsData)
                completion(cases)
            }
        }.resume()
    }
    
    
    func updateSession(param: [String : Any], completion: @escaping (Task) -> Void) {
        
        guard let token = self.token else { return }
            
        var allParams: [String : Any] = param
        allParams["token"] = token
        let req: RequestManager = .update(param: allParams)
        guard let url = URL(string: req.url) else {
            return
        }
        var request = URLRequest(url: url)
        print(request)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: allParams, options: .prettyPrinted) else {
            return
        }
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        print(allParams)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = req.method
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
                   if let response = response {
                       print(response.url)
                   }
            if let parsData = data {
                guard let cases = try?
                        JSONDecoder().decode(Task.self, from: parsData) else { return }
                completion(cases)
            }
        }.resume()
    }
    
    
    func addSession(param: [String: Any], completion: @escaping (Task) -> Void) {
        guard let token = self.token else { return }
        var allParams: [String: Any] = param
        allParams["token"] = token
        let req: RequestManager = .add(param: allParams)
        guard let url = URL(string: req.url) else {
            return 
        }
        var request = URLRequest(url: url)
        let httpBody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        print(param)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = req.method
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(12345678, response, response.url)
            }
            if let parsData = data {
            guard let cases = try?
                JSONDecoder().decode(Task.self, from: parsData) else { return }
                completion(cases)
            }
        }.resume()
    }
    
    
    func deleteSession(param: [String : Int]) {
        let req: RequestManager = .delete(param: param)
        guard let url = URL(string: req.url) else {
            return
        }
        var request = URLRequest(url: url)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) else { return }
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        print(param)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = req.method
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
                   if let response = response {
                       print(response.url)
                   }
        }.resume()
    }
    
    
    func register(param: [String: Any], completion: @escaping (AuthToken) -> Void) {
        let req: RequestManager = .register
        guard let url = URL(string: req.url) else { return }
        var request = URLRequest(url: url)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param) else { return }
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = req.method
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
                   if let response = response {
                       print(response.url)
                   }
            if let parsData = data {
            guard let cases = try?
                    JSONDecoder().decode(AuthToken.self, from: parsData) else { return }
                completion(cases)
            }
        }.resume()
    }
    
    
    func login(param: [String: Any], completion: @escaping (AuthToken) -> Void) {
        let req: RequestManager = .login
        guard let url = URL(string: req.url) else { return }
        var request = URLRequest(url: url)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param) else { return }
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = req.method
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
                   if let response = response {
                       print(response.url)
                   }
            if let parsData = data {
            guard let cases = try?
                JSONDecoder().decode(AuthToken.self, from: parsData) else { return }
                completion(cases)
            }
        }.resume()
    }
}
