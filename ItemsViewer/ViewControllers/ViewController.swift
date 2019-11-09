//
//  ViewController.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import UIKit


final class ViewController: UIViewController {
    
    private lazy var itemService: ItemServiceProtocol = ItemService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        self.itemService.loadItems { (items: [Item]) in
            
        }
        
//        self.itemService.reload(completion: { [weak self] (isReloaded: Bool, error: Error?) in
//
//        })
    }
}

