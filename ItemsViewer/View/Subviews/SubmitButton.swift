//
//  SubmitButton.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import UIKit


final class SubmitButton: UIButton {

    private let theme = Theme.shared
    
    func reloadUI() {
        self.backgroundColor = self.theme.colors.activeColor()
        self.titleLabel?.textColor = self.theme.colors.textSubmitColor()
        self.titleLabel?.font = self.theme.fonts.submitFont()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.theme.sizes.submitButtonRound()
        self.layer.masksToBounds = true
    }
}
