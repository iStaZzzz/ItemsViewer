//
//  Sizes.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import UIKit


class Sizes {
    func screenInsets() -> UIEdgeInsets {
        var insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        
        if #available(iOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets {
                insets.top    += safeAreaInsets.top
                insets.left   += safeAreaInsets.left
                insets.bottom += safeAreaInsets.bottom
                insets.right  += safeAreaInsets.right
            }
        }
        
        return insets
    }
    
    func defaultHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight <= 568 { return 15 }
        
        return 30
    }
    
    func defaultButtonSize() -> CGSize {
        return CGSize(width: 24, height: 24)
    }
    
    func verticalDistance() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight >= 896 { return 30 }
        if screenHeight <= 568 { return 10 }
        
        return 20
    }
    
    func infoViewHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight >= 896 { return 120 }
        
        return 100
    }
    
    // MARK: Submit button
    
    func submitButtonSize() -> CGSize {
        return CGSize(width: 120, height: 40)
    }
    
    func submitButtonRound() -> CGFloat { return 20 }
}
