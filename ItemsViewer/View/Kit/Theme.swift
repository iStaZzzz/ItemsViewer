//
//  Theme.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import UIKit


final class Theme {
    
    static let shared = Theme()
    
    private(set) var colors: Colors
    private(set) var images: Images
    private(set) var sizes:  Sizes
    private(set) var fonts:  Fonts
    
    private(set) var animations: Animations
    
    // MARK:
    
    private init() {
        self.colors = DefaultLightColors()
        self.images = DefaultLightImages()
        self.sizes  = Sizes()
        self.fonts  = Fonts()
        
        self.animations = Animations()
    }
}
