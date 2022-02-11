//
//  OnboardingHostViewController.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-05.
//

import UIKit

protocol OnboardingHostViewControllerDelegate: AnyObject {
    func walkthroughViewControllerDidFinishFlow(_ vc: OnboardingHostViewController)
}

struct OnboardingHostViewControllerActions {
    var walkThroughDone: () -> Void
}

public class OnboardingHostViewController: UIViewController {

     var pageControl:UIPageControl = {
        let pageCont = UIPageControl()
         pageCont.translatesAutoresizingMaskIntoConstraints = false
        return pageCont
    }()
    
     var nextButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    var skipButton:UIButton = {
       let button = UIButton()
       button.translatesAutoresizingMaskIntoConstraints = false
       button.setTitle("Skip", for: .normal)
       return button
   }()
    
    weak var delegate: OnboardingHostViewControllerDelegate?
    var callbacks: OnboardingHostViewControllerActions

    let viewControllers: [UIViewController]
    let uiConfig: OnboardingUIConfigProtocol
    var pageIndex = 0
    let pageController: UIPageViewController
    let fakeVC: UIViewController
    
    //MARK: Custom init
    init(nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?,
         viewControllers: [UIViewController],
         uiConfig: OnboardingUIConfigProtocol,
         callbacks: OnboardingHostViewControllerActions) {
        self.viewControllers = viewControllers
        self.uiConfig = uiConfig
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.fakeVC = UIViewController()
        self.callbacks = callbacks
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        pageControl.numberOfPages = 3
        view.addSubview(pageControl)

        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        pageControl.currentPageIndicatorTintColor = self.uiConfig.indicatorActiveColor
        pageControl.pageIndicatorTintColor = self.uiConfig.indicatorColor
        
        
        view.addSubview(nextButton)
        nextButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.setTitleColor(self.uiConfig.textColor, for: .normal)
        
        view.addSubview(skipButton)
        skipButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        skipButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        skipButton.setTitleColor(self.uiConfig.textColor, for: .normal)
        
        
        
        loadPages()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController.view.frame = self.view.bounds
        pageController.view.setNeedsLayout()
        pageController.view.layoutIfNeeded()
        viewControllers.forEach { (vc) in
            vc.view.frame = self.view.bounds
            vc.view.setNeedsLayout()
            vc.view.layoutIfNeeded()
        }
    }
    
    private func loadPages(){
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        self.addChildViewContWithView(pageController)
        pageControl.numberOfPages = viewControllers.count
        self.view.bringSubviewToFront(pageControl)
        self.view.bringSubviewToFront(nextButton)
        self.view.bringSubviewToFront(skipButton)
    }
    
    private func index(of viewController: UIViewController) -> Int? {
        for (index, vc) in viewControllers.enumerated() {
            if viewController == vc {
                return index
            }
        }
        return nil
    }
    
    @objc func skipButtonTapped() {
        walkThroughDone()
    }
    @objc func nextButtonTapped() {
        moveNext()
    }
    
    private func moveNext() {
        let currentIndex = pageControl.currentPage
        if(currentIndex+1 >= viewControllers.count){
           walkThroughDone()
            return
        }
        
        pageController.setViewControllers([viewControllers[currentIndex+1]], direction:.forward, animated: true){
            data in
            self.pageViewController(self.pageController, didFinishAnimating: true, previousViewControllers: self.viewControllers, transitionCompleted: true)
        }
        
    }
    
    fileprivate func walkThroughDone() {
        guard let delegate = delegate else {
            print("ERROR[143]OnboardingModule OnboardingHostViewController/delegate no exist")
            return
        }
        
        delegate.walkthroughViewControllerDidFinishFlow(self)
    }

}

//MARK: Delegates

extension OnboardingHostViewController: UIPageViewControllerDataSource {
    
    //Return viewcontroller when swipe left
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = self.index(of: viewController) {
            if index == 0 {
                return nil
            }
            return viewControllers[index - 1]
        }
        return nil
    }
    
    //Return viewcontroller when swipe right
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = self.index(of: viewController) {
            if index + 1 >= viewControllers.count {
                return fakeVC
            }
            return viewControllers[index + 1]
        }
        return nil
    }
    
    
}


extension OnboardingHostViewController:UIPageViewControllerDelegate {
    
    //Set active page in UIPageControl when finished animation
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
       
        
        if let lastPushedVC = pageViewController.viewControllers?.last {
            if let index = index(of: lastPushedVC) {
                pageControl.currentPage = index
            } else {
            }
        }
    }

    //for testing
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if pendingViewControllers.first == self.fakeVC {
//            self.removeChildViewCont(self.pageController)
            walkThroughDone()
            
        }
    }
}
