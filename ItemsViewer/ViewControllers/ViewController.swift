//
//  ViewController.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 09.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import UIKit


typealias ViewControllerReloadCompletion = () -> Void


protocol ViewControllerItem: InfoViewPresenterProtocol {
    
}


protocol ViewControllerPresenterProtocol: class {
    
    /// Callback when load completed
    var reloadCompletion: ViewControllerReloadCompletion? { get set }
    
    /// Refresh saved data and than load
    func reload()
    
    /// Load saved data
    func load()
    
    /// Get current  data
    func currentData() -> [ViewControllerItem]
}


// MARK: -

final class ViewController: UIViewController {
    
    private weak var reloadView:  ReloadView?
    private weak var infoView:    InfoView?
    private weak var pageControl: UIPageControl?
    
    private weak var nextButton:  SubmitButton?
    private weak var prevButton:  SubmitButton?

    private let theme = Theme.shared
    
    private var currentItemIndex: Int = 0
    
    private let presenter: ViewControllerPresenterProtocol = ViewControllerPresenter()
    
    // MARK: Override

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
        
        self.presenter.reloadCompletion = { [weak self] () in
            self?.reloadDataUI()
        }
        self.presenter.load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewSize = self.view.frame.size
        let screenInsets = self.theme.sizes.screenInsets()
        let verticalDistance = self.theme.sizes.verticalDistance()
        
        var reloadViewFrame = CGRect.zero
        reloadViewFrame.size = self.theme.sizes.defaultButtonSize()
        reloadViewFrame.origin.y = screenInsets.top
        reloadViewFrame.origin.x = viewSize.width - screenInsets.right - reloadViewFrame.size.width
        self.reloadView?.frame = reloadViewFrame
        
        var nextButtonFrame = CGRect.zero
        nextButtonFrame.size = self.theme.sizes.submitButtonSize()
        nextButtonFrame.origin.y = viewSize.height - screenInsets.bottom - nextButtonFrame.size.height
        nextButtonFrame.origin.x = viewSize.width - screenInsets.right - nextButtonFrame.size.width
        self.nextButton?.frame = nextButtonFrame
        
        nextButtonFrame.origin.x = screenInsets.left
        self.prevButton?.frame = nextButtonFrame
        
        var infoFrame = CGRect.zero
        infoFrame.size.width = viewSize.width - screenInsets.left - screenInsets.right
        infoFrame.size.height = self.theme.sizes.infoViewHeight()
        infoFrame.origin.x = screenInsets.left
        infoFrame.origin.y = nextButtonFrame.origin.y - verticalDistance - infoFrame.size.height
        self.infoView?.frame = infoFrame
        
        var pageControlFrame = CGRect.zero
        pageControlFrame.size.width = viewSize.width - screenInsets.left - screenInsets.right
        pageControlFrame.size.height = self.theme.sizes.defaultHeight()
        pageControlFrame.origin.x = screenInsets.left
        pageControlFrame.origin.y = infoFrame.origin.y - verticalDistance - pageControlFrame.size.height
        self.pageControl?.frame = pageControlFrame
    }
}

private extension ViewController {
    
    func reloadDataUI() {
        DispatchQueue.main.async {
            let items = self.presenter.currentData()
            
            self.pageControl?.numberOfPages = items.count
            
            self.updateSelectedItem(animated: false)
            
            self.reloadView?.stopReloading()
        }
    }
    
    func reloadUI() {
        self.view.backgroundColor = self.theme.colors.backgroundDefault()
        
        self.nextButton?.reloadUI()
        self.nextButton?.setTitle(Localization.loc(key: .next), for: .normal)
        
        self.prevButton?.reloadUI()
        self.prevButton?.setTitle(Localization.loc(key: .prev), for: .normal)
        
        self.pageControl?.pageIndicatorTintColor = self.theme.colors.backgroundPlaceholder()
        self.pageControl?.currentPageIndicatorTintColor = self.theme.colors.activeColor()
    }
}

private extension ViewController {
    
    func addSubviews() {
        self.addReloadView()
        self.addInfoView()
        self.addPageControl()
        self.addNextButton()
        self.addPrevButton()
        
        self.reloadUI()
    }
    
    func addReloadView() {
        if nil != self.reloadView { return }
        
        let view = ReloadView(frame: CGRect.zero)
        view.action = { [weak self] in
            self?.presenter.reload()
        }
        self.view.addSubview(view)
        self.reloadView = view
    }
    
    func addInfoView() {
        if nil != self.infoView { return }
        
        let view = InfoView(frame: CGRect.zero)
        self.view.addSubview(view)
        self.infoView = view
    }
    
    func addPageControl() {
        if nil != self.pageControl { return }
        
        let view = UIPageControl()
        view.addTarget(self, action: #selector(pageControlTap(_:)), for: .valueChanged)
        self.view.addSubview(view)
        self.pageControl = view
    }
    
    func addNextButton() {
        if nil != self.nextButton { return }
        
        let button = SubmitButton(type: .custom)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        self.view.addSubview(button)
        self.nextButton = button
    }
    
    func addPrevButton() {
        if nil != self.prevButton { return }
        
        let button = SubmitButton(type: .custom)
        button.addTarget(self, action: #selector(prevButtonAction), for: .touchUpInside)
        self.view.addSubview(button)
        self.prevButton = button
    }
}

private extension ViewController {
    
    @objc func pageControlTap(_ pageControl: UIPageControl) {
        let index = pageControl.currentPage
        let items = self.presenter.currentData()
        guard index >= 0 else { return }
        guard index < items.count else { return }
        
        self.currentItemIndex = index
        self.updateSelectedItem(animated: true)
    }
    
    @objc func nextButtonAction() {
        let items = self.presenter.currentData()
        if self.currentItemIndex < items.count - 1 {
            self.currentItemIndex += 1
            self.updateSelectedItem(animated: true)
        }
    }
    
    @objc func prevButtonAction() {
        if self.currentItemIndex > 0 {
            self.currentItemIndex -= 1
            self.updateSelectedItem(animated: true)
        }
    }
    
    func updateSelectedItem(animated: Bool) {
        let items = self.presenter.currentData()
        guard self.currentItemIndex >= 0 else { return }
        guard self.currentItemIndex < items.count else { return }
        
        let item = items[self.currentItemIndex]
        self.infoView?.presenter = item
        self.infoView?.reloadDataUI(animated: animated)
        
        self.pageControl?.currentPage = self.currentItemIndex
        
        let animationDuration: TimeInterval = animated ? self.theme.animations.defaultAnimationDuration() : 0
        UIView.animate(withDuration: animationDuration) {
            self.prevButton?.alpha = 1
            self.nextButton?.alpha = 1
            
            if self.currentItemIndex <= 0 {
                self.prevButton?.alpha = 0
            } else if self.currentItemIndex >= items.count - 1 {
                self.nextButton?.alpha = 0
            }
        }
    }
}

