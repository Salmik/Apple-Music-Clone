//
//  UIVIewController + StoryBoard.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 04.05.2020.
//  Copyright © 2020 Zhanibek Lukpanov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromStoryBoard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewcontroller = storyboard.instantiateInitialViewController() as? T {
            return viewcontroller
        } else {
            fatalError("Error: No initial view controller in \(name) storyboard")
        }
    }
    
}
