//
//  PinterestLayout.swift
//  PetnoonTea
//
//  Created by Ninn on 2020/2/1.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(collectionView: UICollectionView,
                        heightForCaptionAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView,
                        heightForPhotoAt indexPath: IndexPath,
                        with width: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    
    weak var delegate: PinterestLayoutDelegate?
    
    var numOfColumns: CGFloat = 2
    var cellPadding: CGFloat = 5
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        let inset = collectionView!.contentInset
        return (collectionView!.bounds.width - (inset.left + inset.right))
    }
    private var attributesCache = [PinterestLayoutAttributes]()
    
    override func prepare() {
        if attributesCache.isEmpty {
            let columnWidth = contentWidth / numOfColumns
            var xOffsets = [CGFloat]()
            for column in 0..<Int(numOfColumns) {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            
            var column = 0
            var yOffsets = [CGFloat](repeating: 0, count: Int(numOfColumns))
            
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let width = columnWidth - cellPadding * 2
                
                // calculate the frame
                let captionHeight: CGFloat = (delegate?.collectionView(collectionView: collectionView!,
                                                                      heightForCaptionAt: indexPath,
                                                                      with: width))!
                let photoHeight: CGFloat = (delegate?.collectionView(collectionView: collectionView!,
                                                                    heightForPhotoAt: indexPath,
                                                                    with: width))!
                let height: CGFloat = cellPadding + captionHeight + photoHeight + cellPadding
                
                let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // create layout attributes
                let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                attributesCache.append(attributes)
                
                // update contentHeight, column, yOffsets
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + height
                
                if column >= (Int(numOfColumns) - 1) {
                    column = 0
                } else {
                    column += 1
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in attributesCache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}

// UICollectionViewFlowLayout
// abstract
class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0.0


    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copy = super.copy(with: zone) as? PinterestLayoutAttributes else {
            return 50
        }
        copy.photoHeight = photoHeight

        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}
