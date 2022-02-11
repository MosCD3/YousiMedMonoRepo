//
//  GeneralCollectionViewController.swift
//  IamAZone
//
//  Created by Mostafa Youssef on 8/20/20.
//  Copyright © 2020 MosCD. All rights reserved.
//

import SwiftUI
import UIKit

public enum CollectionViewStyle {
    case list, grid
}

class AdapterStore {
    fileprivate var store = [String: GenericCollectionRowAdapter]()

    func add(adapter: GenericCollectionRowAdapter, for classString: String) {
        store[classString] = adapter
    }

    func adapter(for classString: String) -> GenericCollectionRowAdapter? {
        return store[classString]
    }
}

protocol GenericCollectionRowAdapter: AnyObject {
    func configure(source:GeneralCollectionViewController,cell: UICollectionViewCell, with object: FRViewable)
    func cellClass() -> UICollectionViewCell.Type
    func size(containerBounds: CGRect, object: FRViewable) -> CGSize
    var fromNib: Bool {get}
    var collectionStyle: CollectionViewStyle {get set}
}


struct GenericCollectionViewControllerConfiguration {
    let pullToRefreshEnabled: Bool
    let pullToRefreshTintColor: UIColor
    let collectionViewBackgroundColor: UIColor
    let collectionViewLayout: FRCollectionViewFlowLayout
    let collectionPagingEnabled: Bool
    let hideScrollIndicators: Bool
    let hidesNavigationBar: Bool
    let headerNibName: String?
    let scrollEnabled: Bool
    let resetOffsetOnUpdate: Bool
    var delegateDataLoad: Bool = false
    var showBackButtonTitle: Bool = false
    var emptyViewModel: FREmptyViewModel? = nil
}

protocol GeneralCollectionViewControllerDelegate: AnyObject {
    
}

protocol GenericCollectionViewScrollDelegate: AnyObject {
    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int)
}


protocol GenericSortDelegate: AnyObject {
    func sortBy(sortType: GenericSortType)
}


class GeneralCollectionViewController: UICollectionViewController, HalfModalPresentable {

    var configuration: GenericCollectionViewControllerConfiguration
    weak var delegate: GeneralCollectionViewControllerDelegate?
    weak var scrollDelegate: GenericCollectionViewScrollDelegate?
    let defaultCellHeight: Double = 50
    
    fileprivate var adapterStore = AdapterStore()
    @available(iOS 13.0, *)
    fileprivate lazy var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    fileprivate lazy var emptyView: UIHostingController<EmptyView>? = nil
    
    var genericDataSource: GenericCollectionViewControllerDataSource? {
        didSet {
            genericDataSource?.delegate = self
        }
    }
    
    init (configuration: GenericCollectionViewControllerConfiguration) {
        self.configuration = configuration
        let layout = configuration.collectionViewLayout
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerReuseIdentifiers()

        if self.configuration.pullToRefreshEnabled {
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        }
        
        collectionView.isPagingEnabled = self.configuration.collectionPagingEnabled
        collectionView.isScrollEnabled = self.configuration.scrollEnabled
        collectionView.backgroundColor = self.configuration.collectionViewBackgroundColor
        
        if configuration.hideScrollIndicators {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
        
        
        
        
        activityIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.minY + 50)
        
        
        collectionView.addSubview(activityIndicator)
        
        
        if !configuration.delegateDataLoad {
                collectionReloadData()
        }
        
        
        //Hide back button title
        if !configuration.showBackButtonTitle {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        
        
        
    }
    
    public func collectionReloadData() {
        activityIndicator.startAnimating()
        print(">> \(String(describing: self))>CollectionView> Fresh loading data .. ")
        genericDataSource?.loadFirst(isRefresh: true)
    }
    
    func registerReuseIdentifiers() {
        adapterStore.store.forEach { (key, adapter) in
            if adapter.fromNib {
                collectionView?.register(UINib(nibName: String(describing: adapter.cellClass()), bundle: nil), forCellWithReuseIdentifier: key)
            } else {
                print("Registering ====>  \(adapter.cellClass())_\(key)")
                collectionView?.register(adapter.cellClass(), forCellWithReuseIdentifier: key)
            }
            
        }
    }
    
    func use(adapter: GenericCollectionRowAdapter, for classString: String) {
        adapterStore.add(adapter: adapter, for: classString)
    }
    
    
    //MARK: Refresh control
    @objc func handleRefreshControl() {
        
        collectionReloadData()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
   
    
    open func listitemSelected(item: FRViewable, index: Int) {
       //implimentation in sub calss
        print("136> default imp")
    }
    
    open func listitemSelectedEdit(item: FRViewable, index: Int) {
        //implimentation in sub calss
        print("141> default imp")
    }
    open func listitemSelectedDelete(item: FRViewable, index: Int) {
        //implimentation in sub calss
        print("141> default imp")
    }
    
    open func setListingThumbnail(item: FRViewable, index: Int) {
        //implimentation in sub calss
        print("191> default imp")
    }
    
    open func chatWithUserIconTapped() {
        //implimentation in sub calss
        print("chatWithUserIconTapped> default imp")
    }
    
    open func handleEmptyViewCallToAction() {
        // To be overriden by subclasses
        print("handleEmptyViewCallToAction> default imp")

    }
    
    
    // MARK: - Private
    private func size(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        if let adapter = self.adapter(at: indexPath), let object = genericDataSource?.object(at: indexPath.row) {
            return adapter.size(containerBounds: collectionView.bounds, object: object)
        }
        return .zero
    }
    
    private func adapter(at indexPath: IndexPath) -> GenericCollectionRowAdapter? {
        if let object = genericDataSource?.object(at: indexPath.row) {
            let stringClass = String(describing: type(of: object))
            if let adapter = adapterStore.adapter(for: stringClass) {
                return adapter
            }
        }
        return nil
    }

}

//MARK: CollectionView methods
extension GeneralCollectionViewController {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return genericDataSource?.numberOfObjects() ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if let object = genericDataSource?.object(at: indexPath.row) {
                
                let stringClass = String(describing: type(of: object))
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stringClass, for: indexPath) as? BaseCollectionViewCell {
                    
                    
                    //get the adpter for that cell
                    if let adapter = adapterStore.adapter(for: stringClass) {
                        cell.delegate = self
                        cell.clipsToBounds = true
                        adapter.configure(source: self, cell: cell, with: object)
                        return cell
                    } else {
                        print("Error[265]FRBasePage: no adpter for cell in path: \(indexPath.row)")
                    }
                } else {
                    print("Error[268]FRBasePage: cannot dequee reusable cell:\(indexPath.row)")
                }
            } else {
                print("Error> no object at index:\(indexPath.row)")
            }
        
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard
            let dataS = self.genericDataSource,
            let item = dataS.object(at: indexPath.row) else {
                print("313> Items nil or no tag")
            return
        }
        
        listitemSelected(item: item, index: indexPath.row)
    }
}

extension GeneralCollectionViewController: FRLiquidLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: indexPath).height
    }

    func collectionViewCellWidth(collectionView: UICollectionView) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: IndexPath(row: 0, section: 0)).width
    }
}

extension GeneralCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.size(collectionView: collectionView, indexPath: indexPath)
    }
}

extension GeneralCollectionViewController: GenericCollectionViewCellDelegate {

    func chatWithUserTapped() {
        chatWithUserIconTapped()
    }
    
    func deleteTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        guard
            let dataS = self.genericDataSource,
            let item = dataS.object(at: indexPath.row) else {
                print("383> deleteTapped> Items nil or no tag")
            return
        }
        
        listitemSelectedDelete(item: item, index: indexPath.row)
    }
    
    func editTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        guard
            let dataS = self.genericDataSource,
            let item = dataS.object(at: indexPath.row) else {
               print("378> Items nil or no tag")
            return
        }
        
        listitemSelectedEdit(item: item, index: indexPath.row)
    }
    
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
//        items.remove(at: indexPath.item)
//        collectionView.performBatchUpdates({
//            self.collectionView.deleteItems(at: [indexPath])
//        })
        
        print("Tapped edit item at index path: \(indexPath)")
    }
    
    func visibleContainerViewTapped(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        print("Tapped item at index path: \(indexPath)")
        
        collectionView(collectionView, didSelectItemAt: indexPath)
        
    }
    
    
    func setThumbnail(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        guard
            let dataS = self.genericDataSource,
            let item = dataS.object(at: indexPath.row) else {
                print("288> setThumbnail> Items nil or no tag")
            return
        }
        
        setListingThumbnail(item: item, index: indexPath.row)
    }
    
}

extension GeneralCollectionViewController: GenericCollectionViewControllerDataSourceDelegate {
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadFirst objects: [FRViewable]?) {
        self.reloadCollectionView()
    }
    
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadBottom objects: [FRViewable]?) {
        print("load bottom")
    }
    
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadTop objects: [FRViewable]?) {
        print("re-load collection view")
    }
}


extension GeneralCollectionViewController {
    private func reloadCollectionView() {
        assert(Thread.isMainThread)
        print("reloaaaad collection view")
//        if let liquidLayout = self.collectionView?.collectionViewLayout as? FRCollectionViewFlowLayout {
//            liquidLayout.invalidateCache()
//        }
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
//        if let parent = self.parent as? ATCGenericCollectionViewController {
//            parent.reloadCollectionView()
//        }
        self.updateAfterLoad()
    }

    private func updateAfterLoad() {

        if configuration.resetOffsetOnUpdate {
            self.collectionView.contentOffset = CGPoint(x: -self.collectionView.contentInset.left, y: -self.collectionView.contentInset.top)
            collectionView.layoutIfNeeded()
        }

        activityIndicator.stopAnimating()
        if (genericDataSource?.numberOfObjects() ?? 0) == 0,
            let emptyViewModel = configuration.emptyViewModel {
            
            let bounds = self.collectionView.bounds
            if emptyView == nil {
                var uiView = EmptyView(model: emptyViewModel)
                uiView.handler = self
                emptyView = UIHostingController(rootView: uiView)
            }
            guard let emptyView = emptyView else { return }
            self.addChildViewControllerWithView(emptyView, toView: self.collectionView)
            emptyView.view.frame = bounds
        }
    }
}

extension GeneralCollectionViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        if w != 0 {
            let page = Int(ceil(x/w))
            scrollDelegate?.genericScrollView(scrollView, didScrollToPage: page)
        }
    }
}


//MARK: Empty view action delegate
extension GeneralCollectionViewController: EmptyViewHandler {
    func didTapActionButton() {
        handleEmptyViewCallToAction()
    }
}


//MARK: Sorting Delegate
extension GeneralCollectionViewController: GenericSortDelegate {
    func sortBy(sortType: GenericSortType) {
        genericDataSource?.sortBy(order: sortType)
    }
}
