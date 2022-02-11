//
//  GenericCollViewDSBase.swift
//  IamAZone
//
//  Created by Mostafa Gamal on 2021-02-21.
//  Copyright © 2021 MosCD. All rights reserved.
//

import UIKit


protocol GenericCollectionViewControllerDataSourceDelegate: AnyObject {
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadFirst objects: [FRViewable]?)
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadBottom objects: [FRViewable]?)
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadTop objects: [FRViewable]?)
}

protocol GenericCollectionViewControllerDataSource: AnyObject {
    var delegate: GenericCollectionViewControllerDataSourceDelegate? {get set}

    func object(at index: Int) -> FRViewable?
    func numberOfObjects() -> Int

    func loadFirst(isRefresh: Bool)
    func loadBottom()
    func loadTop()
    func addItem(item: FRViewable, isReverse: Bool)
    func removeItem(index: Int)
    func replaceItem(at index:Int, with item:FRViewable)
    func filterCollection(filter: Filterable?) -> Bool
    func sortBy(order:GenericSortType)
}

class GenericCollViewDSBase: GenericCollectionViewControllerDataSource {
    
    var delegate: GenericCollectionViewControllerDataSourceDelegate?
    
    open func object(at index: Int) -> FRViewable? {
        print("GenericCollViewDSBase>15 default imp ")
        return nil
    }
    
    open func numberOfObjects() -> Int {
        print("GenericCollViewDSBase>19 default imp")
        return 0
    }
    
    open func loadFirst(isRefresh: Bool) {
        print("GenericCollViewDSBase>26 default imp")
    }
    
    open func loadBottom() {
        print("GenericCollViewDSBase>30 default imp")
    }
    
    open func loadTop() {
        print("GenericCollViewDSBase>34 default imp")
    }
    
    open func addItem(item: FRViewable, isReverse: Bool) {
        print("GenericCollViewDSBase>38 default imp")
    }
    
    open func removeItem(index: Int) {
        print("GenericCollViewDSBase>42 default imp")
    }
    
    open func replaceItem(at index: Int, with item: FRViewable) {
        print("GenericCollViewDSBase>46 default imp")
    }
    
    open func filterCollection(filter: Filterable?) -> Bool {
        print("GenericCollViewDSBase>50 default imp")
        return false
    }
    
    func sortBy(order: GenericSortType) {
        print("GenericCollViewDSBase> orderBy default imp ")
    }
    
}
