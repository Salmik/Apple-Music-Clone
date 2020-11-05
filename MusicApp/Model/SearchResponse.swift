//
//  SearchResponse.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 03.05.2020.
//  Copyright © 2020 Zhanibek Lukpanov. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let resultCount: Int
    let results: [TracksResponse]
}

struct TracksResponse: Codable {
    let trackName: String
    let artworkUrl100: String?
    let collectionName: String?
    let artistName: String
    var previewUrl: String?
}
