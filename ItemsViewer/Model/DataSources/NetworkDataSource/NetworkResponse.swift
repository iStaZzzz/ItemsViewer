//
//  NetworkResponse.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation


private enum CodingKeys: String, CodingKey {
    
    // Common
    case status
    
    // Result
    case result = "pills"
}


enum ResponseStatus: String {
    case error   = "error"
    case success = "ok"
}


struct BaseResponse<T: Decodable>: Decodable {
    let status: ResponseStatus
    let result: T
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let statusString = try container.decode(String.self, forKey: .status)
        if let status = ResponseStatus(rawValue: statusString) {
            self.status = status
        } else {
            self.status = .error
        }
        
        self.result = try container.decode(T.self,    forKey: .result)
    }
}
