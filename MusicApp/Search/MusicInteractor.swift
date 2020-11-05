//
//  MusicInteractor.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 04.05.2020.
//  Copyright (c) 2020 Zhanibek Lukpanov. All rights reserved.
//

import UIKit

protocol MusicBusinessLogic {
  func makeRequest(request: Music.Model.Request.RequestType)
}

class MusicInteractor: MusicBusinessLogic {

  var presenter: MusicPresentationLogic?
  var service: MusicService?
    
  var networkService = NetworkService()
  
  func makeRequest(request: Music.Model.Request.RequestType) {
    if service == nil {
      service = MusicService()
    }
    
    switch request {
        
    case .getTracks(let searchText):
        presenter?.presentData(response: Music.Model.Response.ResponseType.presentFooterView)
        
        networkService.fetchTracks(searchText) {[weak self] (response) in
            guard let self = self else { return }
            self.presenter?.presentData(response: Music.Model.Response.ResponseType.presentTracks(response))
        }
    }
    
  }
  
}
