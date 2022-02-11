//
//  OnboardingCoordinator.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-04.
//

import UIKit

public protocol OnboardingCoordinatorProtocol {
    func start(uiConfig:OnboardingUIConfigProtocol,  views:[UIViewController]?, models:[OnboardingModel]?) -> OnboardingHostViewController
    var delegate:OnboardingCoordinatorActionDelegate? {get set}
}

public protocol OnboardingCoordinatorActionDelegate: AnyObject {
    func onboardingDone()
}

public class OnboardingCoordinator: OnboardingCoordinatorProtocol {
    
    public weak var delegate:OnboardingCoordinatorActionDelegate?
    
    public init(){
        
    }
    public func start(uiConfig: OnboardingUIConfigProtocol, views: [UIViewController]?, models:[OnboardingModel]?) -> OnboardingHostViewController {
      
        var trViews: [UIViewController] = []
        if let v = views {
            trViews = v
        } else if let m = models {
            trViews = m.map { OnboardingTypicalViewController(model: $0, uiConfig: uiConfig, nibName: "OnboardingTypicalViewController", bundle: Bundle(for: OnboardingTypicalViewController.self)) }
        } else {
            print("ERROR Onboarding[24] No view or models passed")
        }
        
        
        //Use that to add some actions to specific onboarding screens
        //or use delegate
        let actions = OnboardingHostViewControllerActions(walkThroughDone: walkThroughDone)
        
        let onboardingHost = OnboardingHostViewController(nibName: nil,
                                                           bundle: nil,
                                                           viewControllers: trViews,
                                                          uiConfig: uiConfig, callbacks: actions)
        onboardingHost.delegate = self
        return onboardingHost
    }
    
    private func walkThroughDone() {
        guard let delegate = delegate else {
            print("ERROR[49]OnboardingModule OnboardingCoordinator / delegate no exist")
            return
        }
        
        delegate.onboardingDone()
    }
}

extension OnboardingCoordinator: OnboardingHostViewControllerDelegate {
    func walkthroughViewControllerDidFinishFlow(_ vc: OnboardingHostViewController) {
        walkThroughDone()
    }
}
