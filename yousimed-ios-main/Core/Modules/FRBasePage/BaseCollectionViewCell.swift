//
//  BaseCollectionViewCell.swift
//  IamAZone
//
//  Created by Mostafa Gamal on 2020-11-15.
//  Copyright © 2020 MosCD. All rights reserved.
//
import UIKit

protocol GenericCollectionViewCellDelegate: AnyObject {
    func visibleContainerViewTapped(inCell cell: UICollectionViewCell)
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell)
    func deleteTapped(inCell cell: UICollectionViewCell)
    func editTapped(inCell cell: UICollectionViewCell)
    func setThumbnail(inCell cell: UICollectionViewCell)
    func chatWithUserTapped()
}

class BaseCollectionViewCell: UICollectionViewCell {

    var cellModel: FRViewable?
    
    weak var delegate: GenericCollectionViewCellDelegate?
    
    let accessoryMore: UIImageView = {
        let image = UIImage(named: "arrow_forward_icon")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .gray
        return imageView
    }()
    
    let lineBreaker: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor(hexString: "#e4e4e4")
        return _view
    }()
    
    var hasMoreItems: Bool? {
        didSet {
            if let val  = hasMoreItems, val == true {
                addSubview(accessoryMore)
                
                accessoryMore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
                accessoryMore.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                accessoryMore.widthAnchor.constraint(equalToConstant: 15).isActive = true
                accessoryMore.heightAnchor.constraint(equalToConstant: 15).isActive = true
            }
        }
    }
    
    open func cellPreparingForReuse() {
        
    }
    
    override func prepareForReuse() {
        accessoryMore.removeFromSuperview()
        cellPreparingForReuse()
    }
}
