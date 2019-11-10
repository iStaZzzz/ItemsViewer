//
//  InfoView.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import UIKit


protocol InfoViewPresenterProtocol {
    func title() -> String
    func description() -> String
}


final class InfoView: UIView {
    private weak var titleLabel: UILabel?
    private weak var descriptionLabel: UILabel?

    private let theme = Theme.shared
    
    // MARK:
    
    var presenter: InfoViewPresenterProtocol?
    
    
    func reloadDataUI(animated: Bool) {
        let animationDuration = animated ? self.theme.animations.defaultAnimationDuration() : 0
        
        self.titleLabel?.change(text: self.presenter?.title(), animationDuration: animationDuration)
        self.descriptionLabel?.change(text: self.presenter?.description(), animationDuration: animationDuration)
    }
        
    // MARK: Override
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width:  CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height
        let inset:  CGFloat = self.theme.sizes.verticalDistance()
        
        let textHeight: CGFloat = (height - inset) / 2
        
        var textFrame = CGRect(x: 0, y: 0, width: width, height: textHeight)
        self.titleLabel?.frame = textFrame
        
        textFrame.origin.y = textHeight + inset
        self.descriptionLabel?.frame = textFrame
    }

}

private extension InfoView {
    
    func addSubviews() {
        self.addTitleLabel()
        self.addDescriptionLabel()

        self.updateUI()
    }
    
    func addTitleLabel() {
        if nil != self.titleLabel { return }
        
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        
        self.addSubview(label)
        
        self.titleLabel = label
    }

    func addDescriptionLabel() {
        if nil != self.descriptionLabel { return }
        
        let label = UILabel()
        label.numberOfLines = 0
        
        self.addSubview(label)
        
        self.descriptionLabel = label
    }
}

private extension InfoView {
    
    func updateUI() {
        self.titleLabel?.textColor = self.theme.colors.textTitleColor()
        self.titleLabel?.font = self.theme.fonts.titleFont()
        
        self.descriptionLabel?.textColor = self.theme.colors.textDescriptionColor()
        self.descriptionLabel?.font = self.theme.fonts.descriptionFont()
    }
}

