//
//  Item.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation


struct Item: Decodable {
    let id: Int
    
    let name: String
    let description: String
    
    let image: String
    
    let dose: String
    
    init(id: Int, name: String, description: String, image: String, dose: String) {
        self.id = id
        
        self.name = name
        self.description = description
        
        self.image = image
        
        self.dose = dose
    }
    
    // MARK: Decodable
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description = "desription"
        case img
        case dose
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .identifier)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        
        self.image = try container.decode(String.self, forKey: .img)
        
        self.dose = try container.decode(String.self, forKey: .dose)
    }
}
