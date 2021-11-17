//
//  BaseNavigationController.swift
//  FlashCardApp
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        hidesBottomBarWhenPushed = true
    }
}
