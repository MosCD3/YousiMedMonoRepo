//
//  Presentable.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-27.
//

import UIKit

protocol Presentable: AnyObject {
    func getViewController() -> UIViewController
}
