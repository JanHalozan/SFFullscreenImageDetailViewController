//
//  ViewController.swift
//  SFFullscreenImageDetailViewControllerDemo
//
//  Created by Jan Haložan on 26/01/16.
//  Copyright © 2016 JanHalozan. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBAction func imageTap(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        
        let viewController = SFFullscreenImageDetailViewController(imageView: imageView)
        viewController.presentInCurrentKeyWindow()
    }
}

