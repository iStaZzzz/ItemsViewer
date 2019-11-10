//
//  Config.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation


final class Config {
    private init() {  }
    
    static let shared = Config()
    
    // MARK: Network
    let baseNetworkURL: String = "https://cloud.fdoctor.ru/"
    let itemsNetworkPath: String = "test_task/"
}
