//
//  Nib.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 05.11.2020.
//  Copyright © 2020 Zhanibek Lukpanov. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }
}
