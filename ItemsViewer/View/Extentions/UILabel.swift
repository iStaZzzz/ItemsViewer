//
//  UILabel.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import UIKit


extension UILabel {
    
    func change(text: String?, animationDuration: TimeInterval) {
        
        let animation: (() -> Void)? = { [weak self] in
            self?.text = text
        }
        
        UIView.transition(with: self,
                          duration: animationDuration,
                          options: .transitionCrossDissolve,
                          animations: animation,
                          completion: nil)
    }
}

