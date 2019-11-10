//
//  ImageViewer.swift
//  ItemsViewer
//
//  Created by Stanislav Ivanov on 10.11.2019.
//  Copyright © 2019 Stanislav Ivanov. All rights reserved.
//


import UIKit


protocol ImageViewerItemProtocol {
    func urlString() -> String
}

typealias ImageViewerDidScroll = (_ scrolledPage: Int) -> Void


final class ImageViewer: UIView {

    private weak var collectionView: UICollectionView?
    
    private let theme = Theme.shared
    
    private var items: [ImageViewerItemProtocol] = []
    
    // MARK:
    
    var didScrollCompletion: ImageViewerDidScroll?
    
    private(set) var currentPage: Int = 0
    
    func scrollTo(page: Int, animated: Bool) {
        guard page != self.currentPage else { return }
        
        self.currentPage = page
        let indexPath = IndexPath(item: self.currentPage, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    func reload(items: [ImageViewerItemProtocol]) {
        self.items.removeAll()
        self.items.append(contentsOf: items)
        self.collectionView?.reloadData()
    }
    
    func reloadUI() {
        self.backgroundColor = self.theme.colors.backgroundDefault()
        self.collectionView?.backgroundColor = self.theme.colors.backgroundDefault()
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
        self.collectionView?.frame = self.bounds
        
        (self.collectionView?.collectionViewLayout as? CarouselFlowLayout)?.updateLayout()
    }
}

private extension ImageViewer {
    
    func addSubviews() {
        self.addCollectionView()
        
        self.reloadUI()
    }
    
    func addCollectionView() {
        if nil != self.collectionView { return }
        
        let flowLayot = CarouselFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayot)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        
        self.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
}

extension ImageViewer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath)
        
        if let imageCollectionViewCell = cell as? ImageCollectionViewCell {
            let item = self.items[indexPath.row]
            imageCollectionViewCell.reload(item: item)
        }
        
        return cell
    }

}

extension ImageViewer: UICollectionViewDelegate {
    
}

extension ImageViewer: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let layout = self.collectionView?.collectionViewLayout as? CarouselFlowLayout else {
            return
        }
        
        guard let didScrollCompletion = self.didScrollCompletion else {
            return
        }
        
        let pageSide = layout.itemSize.width + layout.minimumLineSpacing
        let offset = scrollView.contentOffset.x
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        
        if currentPage != self.currentPage {
            self.currentPage = currentPage
            didScrollCompletion(currentPage)
        }
    }
}


// MARK: -

fileprivate class ImageCollectionViewCell: UICollectionViewCell {
 
    static let identifier: String = "ImageCollectionViewCell"
    
    func reloadUI() {
        self.backgroundColor = self.theme.colors.backgroundDefault()
        
        self.imageView?.backgroundColor = self.theme.colors.backgroundPlaceholder()
        self.imageView?.layer.cornerRadius = 10
    }
    
    func reload(item: ImageViewerItemProtocol) {
        
    }
    
    // MARK:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.frame = self.bounds
    }
    
    
    // MARK:
    
    private weak var imageView: UIImageView?
    
    private let theme = Theme.shared
    
    private func addSubviews() {
        self.addImageView()
        
        self.reloadUI()
    }
    
    private func addImageView() {
        if nil != self.imageView { return }
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        self.addSubview(imageView)
        
        self.imageView = imageView
    }
}


// MARK: -

fileprivate class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    private let sideItemScale: CGFloat = 0.8
    
    // MARK:

    override open func prepare() {
        super.prepare()
        
        self.minimumLineSpacing = 10
        self.scrollDirection = .horizontal
        self.setupCollectionView()
        self.updateLayout()
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        
        
        
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView , !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let midSide = collectionView.bounds.size.width / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide
        
        var targetContentOffset: CGPoint
        let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
        targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        
        return targetContentOffset
    }
    
    // MARK:
    
    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }

        let collectionCenter = collectionView.frame.size.width / 2
        let offset = collectionView.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        let shift = (1 - ratio)
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.center.y = attributes.center.y + shift
        
        return attributes
    }
    
    fileprivate func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    fileprivate func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let width: CGFloat = collectionView.frame.size.width / 3 * 2
        let height: CGFloat = collectionView.frame.size.height
        self.itemSize = CGSize(width: width, height: height)
        
        let collectionSize = collectionView.bounds.size
        
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsets.init(top: yInset, left: xInset, bottom: yInset, right: xInset)
    }
}

