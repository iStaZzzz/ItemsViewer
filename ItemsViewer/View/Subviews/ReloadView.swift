//
//  ReloadView.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//

import UIKit


typealias ReloadViewAction = () -> Void

protocol ReloadViewProtocol: class {
    var action: ReloadViewAction? { set get }
    
    func startReloading()
    func stopReloading()
}


// MARK: -

final class ReloadView: UIView {
    private weak var reloadButton: UIButton?
    private weak var activityIndicator: UIActivityIndicatorView?

    private let theme = Theme.shared
    
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
        
        self.reloadButton?.frame = self.bounds
        self.activityIndicator?.frame = self.bounds
    }
    
    // MARK: ReloadViewProtocol
    
    internal var action: ReloadViewAction?
    
    func startReloading() {
        self.activityIndicator?.startAnimating()
        self.reloadButton?.isHidden = true
    }
    
    func stopReloading() {
        self.activityIndicator?.stopAnimating()
        self.reloadButton?.isHidden = false
    }
}

private extension ReloadView {
    
    func addSubviews() {
        self.addReloadButton()
        self.addActivityIndicator()
        
        self.stopReloading()
    }
    
    func addReloadButton() {
        if nil != self.reloadButton { return }
        
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTaped), for: .touchUpInside)
        button.setImage(self.theme.images.refreshImage(), for: .normal)
        
        self.addSubview(button)
        
        self.reloadButton = button
    }
    
    func addActivityIndicator() {
        if nil != self.activityIndicator { return }
        
        var activityIndicator: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .white)
        }
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.theme.colors.activeColor()
        
        self.addSubview(activityIndicator)
        
        self.activityIndicator = activityIndicator
    }
}

private extension ReloadView {
    
    @objc func didTaped() {
        self.startReloading()
        if let action = self.action {
            action()
        }
    }
}
