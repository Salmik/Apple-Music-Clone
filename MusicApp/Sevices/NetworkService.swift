//
//  NetworkService.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 03.05.2020.
//  Copyright © 2020 Zhanibek Lukpanov. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(_ searchText: String, completionHandler: @escaping (SearchResponse) -> Void) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)",
                          "limit":"29",
                          "media":"music" ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).validate().responseJSON {(response) in
            
             if let error = response.error {
                 print(error.localizedDescription)
                 return
             }
            
             guard let data = response.data else { return }
             
             do {
                 let objects = try JSONDecoder().decode(SearchResponse.self, from: data)
                 completionHandler(objects)
             } catch {
                 print("Error with JsonDecoder")
             }
        }
    }
}
