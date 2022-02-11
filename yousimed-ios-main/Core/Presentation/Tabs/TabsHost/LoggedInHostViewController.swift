//
//  LoogedInHostViewController.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-16.
//

import UIKit

class LoggedInHostViewController: UIViewController {
    
    
    var tabs: [TabNavItem]
    
    init(presenter: TabsHostPresenterProtocol,
         tabs:[TabNavItem]) {
        
        self.tabs = tabs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let button = UIButton()
//        button.setTitle("Log out", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(button)
//        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        button.addTarget(self, action: #selector(doLogOut), for: .touchUpInside)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .black
        configureTabs()
        // Do any additional setup after loading the view.
    }
    
    func configureTabs() {
        
        let tabController: UITabBarController = UITabBarController()
       
        
        //Configure Tab Icon button for each view controller
        for (tag, item) in tabs.enumerated() {
            
            let tabBarItem = UITabBarItem(title: item.title, image: item.image, tag: tag)
            if let selectedImage = item.selectedImage {
                tabBarItem.selectedImage = selectedImage
            }
            if item.title == nil {
                tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
            }
            
            item.viewController?.tabBarItem = tabBarItem
            item.viewController?.title = item.title
        }
        
        
        //Add Viewcontrollers to Tab Host view
        let navigationControllers: [UINavigationController] = tabs.compactMap {
            
            guard let navVc = $0.viewController else {
                return nil
            }
            
            return UINavigationController(rootViewController: navVc)
            
        }
        
        //Adding ViewControllers to tab controller
        tabController.setViewControllers(navigationControllers, animated: true)
        
        addChildViewControllerWithView(tabController)
    }
    
    
    @objc func doLogOut() {
//        coordinator.logOut()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
