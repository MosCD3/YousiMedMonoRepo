//
//  HpItemCell.swift
//  IamAZone
//
//  Created by Mostafa Youssef on 7/30/20.
//  Copyright © 2020 MosCD. All rights reserved.
//

import UIKit

class HpItemCell: UITableViewCell {

//    var menuItem: CollectionViewItem? {
//        didSet {
//            guard let menuItem = menuItem else {
//                return
//            }
//            
//            info1Label.text = menuItem.label
//            info3Label.text = menuItem.description
//        }
//    }
    let info1Label:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let info2Label:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        label.sizeToFit()
        label.textColor =  .white
        label.backgroundColor = UIColor(hexString: "#c7cac7")
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let info3Label:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(hexString: "#919191")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countryImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit // without this your image will shrink and looks ugly
        img.translatesAutoresizingMaskIntoConstraints = false
        //        img.layer.cornerRadius = 13
        //        img.clipsToBounds = true
        return img
    }()
    
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit // image will never be strecthed vertially or horizontally
        //        img.layer.cornerRadius = 35
        //        img.clipsToBounds = true
        img.image = UIImage(named: "icon-check-all")
        return img
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(profileImageView)
        containerView.addSubview(info1Label)
//        containerView.addSubview(info2Label)
        containerView.addSubview(info3Label)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(countryImageView)
        
        
        
        profileImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true

        
        containerView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 30).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: -10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        info1Label.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20).isActive = true
        info1Label.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        info1Label.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        
        
        info3Label.topAnchor.constraint(equalTo: self.info1Label.bottomAnchor, constant: 15).isActive = true
        info3Label.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        info3Label.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        

        
        countryImageView.widthAnchor.constraint(equalToConstant:26).isActive = true
        countryImageView.heightAnchor.constraint(equalToConstant:26).isActive = true
        countryImageView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-20).isActive = true
        countryImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
