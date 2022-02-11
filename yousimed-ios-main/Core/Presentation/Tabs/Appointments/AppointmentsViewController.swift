//
//  AppointmentsViewController.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-28.
//

import UIKit

class AppointmentsViewController: UIViewController {

    
    var presenter: AppointmentsPresenterProtocol
    var dependency: AppDIContainerProtocol
    
    init(dependency: AppDIContainerProtocol,
         presenter: AppointmentsPresenterProtocol) {
        self.dependency = dependency
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = dependency.uiConfig.mainThemeBackgroundColor
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.text = "Appointment page content"
        view.addSubview(label)
        
        label.center = view.center
        label.textColor = .black

        // Do any additional setup after loading the view.
    }
    
    //MARK: Creating the View
    static func create(dependency:AppDIContainerProtocol,
                       with: AppointmentsPresenterProtocol) -> AppointmentsViewController {
        let view = AppointmentsViewController(dependency: dependency, presenter: with)
        return view
    }

}
