//
//  NetworkManager.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation


enum NetworkManagerError: Error {
    case canNotCreateRequest
    case emptyData
    case jsonError
}


typealias NetworkManagerCompletion<T: Decodable> = (_ result: T?, _ error: Error?) -> Void


protocol NetworkManagerProtocol {
    func execute<T: Decodable>(request: NetworkRequestProtocol?, completion: @escaping NetworkManagerCompletion<T> )
}


// MARK: -
final class NetworkManager {
    
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    private init() {}
    
    private let decoder = JSONDecoder()
}

extension NetworkManager: NetworkManagerProtocol {
    
    func execute<T: Decodable>(request: NetworkRequestProtocol?, completion: @escaping NetworkManagerCompletion<T> ) {
        
        guard let urlRequest = request?.build() else {
            completion(nil, NetworkManagerError.canNotCreateRequest)
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (_ data: Data?, response: URLResponse?, error: Error?) in
            
            #if DEBUG
            debugPrint("urlRequest \(urlRequest)")
            var responseString = "Empty response"
            if let data = data {
                responseString = String(data: data, encoding: .utf8) ?? "Wrong data"
            }
            debugPrint("responseString \(responseString)")
            #endif
            
            let (result, completionError): (T?, Error?) = self.parseResult(data: data, error: error)
            completion(result, completionError)
        }
        dataTask.resume()
    }
    
    private func parseResult<T: Decodable>(data: Data?, error: Error?) -> (T?, Error?) {
        var completionError: Error? = nil
        var result: T? = nil

        if let error = error {
            completionError = error
        } else if let data = data {
            do {
                result = try self.decoder.decode(T.self, from: data)
            } catch {
                completionError = NetworkManagerError.jsonError
                debugPrint("Exception \(#file) \(#function) \(#line) \(error)")
            }
            
        } else {
            completionError = NetworkManagerError.emptyData
        }
        
        return (result, completionError)
    }
}

