//
//  MusicPresenter.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 04.05.2020.
//  Copyright (c) 2020 Zhanibek Lukpanov. All rights reserved.
//

import UIKit

protocol MusicPresentationLogic {
  func presentData(response: Music.Model.Response.ResponseType)
}

class MusicPresenter: MusicPresentationLogic {
    weak var viewController: MusicDisplayLogic?
    
    func presentData(response: Music.Model.Response.ResponseType) {
        
        switch response {
        
        case .presentTracks(let tracks):
            
            let cells = tracks?.results.map({ (track) in
                cellViewModel(from: track)
            }) ?? []
            
            let searchViewModel = SearchViewModel.init(cells: cells)
            viewController?.displayData(viewModel: Music.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel))
            
        case .presentFooterView:
            viewController?.displayData(viewModel: Music.Model.ViewModel.ViewModelData.displayFooterView)
        }
        
    }
    
    private func cellViewModel(from track: TracksResponse) -> SearchViewModel.Cell {
        
        return SearchViewModel.Cell.init(iconUrlString: track.artworkUrl100,
                                         trackName: track.trackName,
                                         collectionName: track.collectionName ?? "",
                                         artistName: track.artistName,
                                         previewUrl: track.previewUrl)
    }
    
}
