//
//  MusicViewController.swift
//  MusicApp
//
//  Created by Zhanibek Lukpanov on 04.05.2020.
//  Copyright (c) 2020 Zhanibek Lukpanov. All rights reserved.
//

import UIKit

protocol MusicDisplayLogic: class {
    func displayData(viewModel: Music.Model.ViewModel.ViewModelData)
}

class MusicViewController: UIViewController, MusicDisplayLogic {
    
    var interactor: MusicBusinessLogic?
    var router: (NSObjectProtocol & MusicRoutingLogic)?
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var searchViewModel = SearchViewModel.init(cells: [])
    
    private lazy var footerView = FooterView()
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    var timer: Timer?
    
    // MARK: Object lifecycle
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = MusicInteractor()
        let presenter             = MusicPresenter()
        let router                = MusicRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setupSearchController()
        searchBar(searchController.searchBar, textDidChange: "Rihana")
    }
    
    func displayData(viewModel: Music.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
            
        case .displayTracks(let searchViewModel):
            self.searchViewModel = searchViewModel
            tableView.reloadData()
            footerView.hideLoader()
            
        case .displayFooterView:
            footerView.showLoader()
        }
    }
    
    func setupTableView() {
//      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        tableView.tableFooterView = footerView
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск треков"
        searchController.searchBar.delegate = self
    }
    
}

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        
        let searchModelForCell = searchViewModel.cells[indexPath.row]
    
        cell.set(viewModel: searchModelForCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchModelForCell = searchViewModel.cells[indexPath.row]
        
        // 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
        
//        let window = UIApplication.shared.connectedScenes
//        .filter({$0.activationState == .foregroundActive})
//        .map({$0 as? UIWindowScene})
//        .compactMap({$0})
//        .first?.windows
//        .filter({$0.isKeyWindow}).first
//
//        let trackView: TrackDetailView = TrackDetailView.loadFromNib()
//
//        trackView.set(viewModel: searchModelForCell)
//        trackView.delegate = self
//
//        window?.addSubview(trackView)
        
        self.tabBarDelegate?.maximizeTrackDetail(viewModel: searchModelForCell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 290
    }
    
}

extension MusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: {[weak self] (_) in
            guard let text = searchBar.text else { return }
            self?.interactor?.makeRequest(request: Music.Model.Request.RequestType.getTracks(searchText: text))
        })
       
    }
}

extension MusicViewController: TrackMovingDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        
        var nextIndexPath: IndexPath!
        
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
            }
        }
        
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = searchViewModel.cells[nextIndexPath.row]
        return cellViewModel
        
    }
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        print(#function)
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        print(#function)
        return getTrack(isForwardTrack: true)
    }
    
}
