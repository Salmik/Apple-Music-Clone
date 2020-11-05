//
//  MusicModels.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 04.05.2020.
//  Copyright (c) 2020 Zhanibek Lukpanov. All rights reserved.
//

import UIKit

enum Music {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTracks(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(SearchResponse?)
        case presentFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(searchViewModel: SearchViewModel)
        case displayFooterView
      }
    }
  }
  
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel  {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
