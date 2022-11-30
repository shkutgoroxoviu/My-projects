//
//  MainConfigurator.swift
//  WorkWithData
//
//  Created by Гурген Хоршикян on 30.11.2022.
//

import Foundation
import UIKit

class MainConfigurator {
    static func config() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NameListViewController") as! NameListViewController
        let presenter = NameListPresenter()
        vc.presenter = presenter
        presenter.view = vc
        
        return UINavigationController(rootViewController: vc)
    }
}
