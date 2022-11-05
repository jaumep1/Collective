//
//  AuthManager.swift
//  Collective
//
//  Created by Jaume Pujadas on 7/28/22.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var onRefreshBlocks = [((String) -> Void)]()
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "4152c68257f44a4cad18aae3c4fb6092"
        static let clientSecret = "9adca897a5064a939bc2ae5bdc38eff7"
        static let tokenAPIUrl = "https://accounts.spotify.com/api/token"
        /*
         NOTE ABOUT ADDING MORE SCOPES
         
         ADD SCOPES IN FOLLOWING FORMAT: "scope%20scope%20scope"
         FULL LIST OF SCOPES AVAILABLE ON SPOTIFY API DOCS
         */
        static let scopes = "user-read-private%20user-read-email%20user-read-recently-played%20playlist-read-collaborative%20user-top-read%20user-library-read%20playlist-read-private%20user-read-private"
        static let redirectURI = "https://google.com/"//"Collective://"
    }
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    private init() {}
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")

    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date

    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false;
        }
        
        let currentDate = Date()
        let buffer : TimeInterval = 300
        return currentDate.addingTimeInterval(buffer) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String,
                                     completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenAPIUrl) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)",
                         forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
            }
        }
        task.resume()
    }
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if (shouldRefreshToken) {
            refreshAccessToken { [weak self] success in
                if let token = self?.accessToken {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshAccessToken(completion: @escaping ((Bool) -> Void)) {
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = refreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIUrl) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_code"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)",
                         forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
            }
        }
        task.resume()

        
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
