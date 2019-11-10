//
//  ViewControllerPresenter.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation



class ViewControllerItemAdapter: ViewControllerItem {
    
    private let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    // MARK: InfoViewPresenterProtocol
    
    func title() -> String {
        return item.name
    }
    
    func description() -> String {
        return item.description + ".\n" + item.dose + "."
    }
}



final class ViewControllerPresenter: ViewControllerPresenterProtocol {
    
    // MARK:
    
    private lazy var itemService: ItemServiceProtocol = ItemService.shared
    
    private var viewControllerItems: [ViewControllerItem] = []
    
    // MARK: ViewControllerPresenterProtocol
    
    var reloadCompletion: ViewControllerReloadCompletion?
    
    func currentData() -> [ViewControllerItem] {
        return self.viewControllerItems
    }
    
    func reload() {
        self.itemService.reload(completion: { [weak self] (isReloaded: Bool, error: Error?) in
            if isReloaded {
                self?.load()
            }
        })
    }
    
    func load() {
        self.itemService.loadItems { [weak self]  (items: [Item]) in
            self?.viewControllerItems.removeAll()
            
            for item in items {
                let viewControllerItem = ViewControllerItemAdapter(item: item)
                self?.viewControllerItems.append(viewControllerItem)
            }
            
            if let reloadCompletion = self?.reloadCompletion {
                reloadCompletion()
            }
        }
    }
}

