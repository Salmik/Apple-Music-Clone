//
//  CMTime + Extension.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 04.11.2020.
//  Copyright © 2020 Zhanibek Lukpanov. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minus = totalSeconds / 60
        let timeFormattedString = String(format: "%02d:%02d", minus, seconds)
        return timeFormattedString
    }
}
