//
//  ItemService.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation


typealias ItemServiceReloadCompletion = (_ isReloaded: Bool, _ error: Error?) -> Void
typealias ItemServiceLoadItemsCompletion = (_ item: [Item]) -> Void


protocol ItemServiceProtocol {
    func reload(completion: @escaping ItemServiceReloadCompletion)
    func loadItems(completion: @escaping ItemServiceLoadItemsCompletion)
}


final class ItemService {
    
    static let shared: ItemServiceProtocol = ItemService()
    
    // MARK:
    
    private lazy var networkManager: NetworkManagerProtocol = NetworkManager.shared
    private lazy var dbDataSource: DBDataSourceProtocol = DBDataSource.shared
    
    private init() { }
}


// MARK: -

extension ItemService: ItemServiceProtocol {
    
    func loadItems(completion: @escaping ItemServiceLoadItemsCompletion) {
        self.dbDataSource.loadItems { (items: [Item]) in
            completion(items)
        }
    }
    
    func reload(completion: @escaping ItemServiceReloadCompletion) {
        let request = ItemsNetworkRequest()
        let requestCompletion: NetworkManagerCompletion<BaseResponse<[Item]>> = { (response: BaseResponse<[Item]>?, error: Error?) in
            
            if response?.status == .success, let items = response?.result {
                self.dbDataSource.save(items: items) { (isSaved: Bool) in
                    completion(isSaved, nil)
                }
            } else {
                completion(false, error)
            }
        }
        self.networkManager.execute(request: request, completion: requestCompletion)
    }
}
