//
//  Colors.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import UIKit


class Colors {
    func activeColor() -> UIColor { return UIColor.blue }
    
    // MARK: Backgrounds
    
    func backgroundDefault() -> UIColor { return UIColor.white }
    func backgroundPlaceholder() -> UIColor { return UIColor.gray }
    
    // MARK: Text colors
    
    func textTitleColor() -> UIColor { return UIColor.black }
    
    func textSubmitColor() -> UIColor { return UIColor.white }
    
    func textDescriptionColor() -> UIColor { return UIColor.darkGray }
}


class DefaultLightColors: Colors {
    
}

class DefaultDarkColors: Colors {
    
}

