//
//  Localization.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import Foundation



enum ErrorKey: String {
    case alertTitle = "ErrorKey.alertTitle"
    case unknownDescription = "ErrorKey.unknownDescription"
}


final class Localization {
    
    static func loc(key: ErrorKey) -> String {
        return self.loc(key: key.rawValue)
    }
    
    static func loc(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
