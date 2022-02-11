//
//  OnboardingTypicalViewController.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-06.
//

import UIKit

class OnboardingTypicalViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    let model: OnboardingModel
    let uiConfig: OnboardingUIConfigProtocol

    init(model: OnboardingModel,
         uiConfig: OnboardingUIConfigProtocol,
         nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?) {
        self.model = model
        self.uiConfig = uiConfig
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage.fromLocalImage(model.icon, template: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = uiConfig.iconColor
        imageContainerView.backgroundColor = .clear

        titleLabel.text = model.title
        titleLabel.font = uiConfig.titleFont
        titleLabel.textColor = uiConfig.textColor

        subtitleLabel.attributedText = NSAttributedString(string: model.subtitle)
        subtitleLabel.font = uiConfig.descriptionFont
        subtitleLabel.textColor = uiConfig.textColor

        containerView.backgroundColor = uiConfig.defaultBackgroundColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.frame = self.view.bounds
    }

}
