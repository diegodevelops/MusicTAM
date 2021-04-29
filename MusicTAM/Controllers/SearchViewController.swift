//
//  SearchViewController.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    // MARK: - Properties
    private let convenience = Convenience.sharedInstance()
    private let RID = "AlbumTableViewCell"
    private let RID_PLACEHOLDER = "PlaceholderTableViewCell"
    private let SID = "AlbumsViewController"
    private var artists = [Artist]()
    private var searchMode: SearchMode = .Home
    private var searchTerm = ""
    private var searchBar: UISearchBar!
    private let toast = UILabel()
    private var autoScrolling = false
    
    /// API helpers
    private var dataSource: ArtistDataSource!
    private var repo: RestRepository!
    private var webService: WebService!
    private var webServiceUrlBuilder: WebServiceURLProviderBuilder!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // updating nav bar here in case it was modified on other pushed view controllers
        convenience.updatenNavbarTitle(selfController: self, withTitle: "MusicTAM", fontName: "Menlo-Bold", fontSize: 17, fontColor: .black)
    }
    
    // MARK: - only once
    private func setUp() {
        // searchBar
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64))
        searchBar.placeholder = "search for an artist or group"
        searchBar.delegate = self
        searchBarContainer.addSubview(searchBar)
        // tableView
        tableView.register(ArtistTableViewCell.self, forCellReuseIdentifier: RID)
        tableView.register(PlaceholderTableViewCell.self, forCellReuseIdentifier: RID_PLACEHOLDER)
        // toast
        convenience.createToast(toast: toast, view: view, withBackgroundColor: UIColor.black.withAlphaComponent(0.8), fontName: "Helvetica-Bold", fontSize: 14, fontColor: UIColor.white)
        // API helpers
        webService = WebService()
        repo = RestRepository(webService: webService)
        webServiceUrlBuilder = WebServiceURLProviderBuilder()
        dataSource = DataSource(repository: repo, webServiceURLProvider: webServiceUrlBuilder.getProvider(for: Compilation.environment))
    }
    
    // MARK: - search helpers
    private func searchDone() {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        searchTerm = ""
        searchMode = .Home
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    private func searchAndHandle() {
        searchMode = .Active
        tableView.reloadData()
        dataSource.getArtists(searchTerm: searchTerm, page: nil, limit: nil, needsLoader: nil, completion: {
            [weak self] artistResponse in
            if let artistResponse = artistResponse,
               let firstArtistResponse = artistResponse.first,
               let artists = firstArtistResponse.results {
                self?.searchMode = .Success
                self?.artists = artists
                performUIUpdatesOnMain { self?.tableView.reloadData() }
            } else {
                self?.searchMode = .Error
                performUIUpdatesOnMain { self?.tableView.reloadData() }
            }
        }, failure: {
            [weak self] errorMsg in
            self?.searchMode = .Error
            performUIUpdatesOnMain { self?.tableView.reloadData() }
        })
    }
    
    // MARK: - push or present
    private func pushAlbumsViewController(artist: Artist) {
        let vc = storyboard?.instantiateViewController(identifier: SID) as! AlbumsViewController
        vc.artist = artist
        navigationItem.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count == 0 ? 1 : artists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if artists.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RID_PLACEHOLDER) as! PlaceholderTableViewCell
            var placeholderTxt = ""
            switch searchMode {
            case .Home:
                cell.activityIndicator.stopAnimating()
                placeholderTxt = "Hi! Let's search for a music artist or group"
            case .Active:
                cell.activityIndicator.startAnimating()
                placeholderTxt = "Searching for '\(searchTerm)'..."
            case .Success:
                cell.activityIndicator.stopAnimating()
                placeholderTxt = "Ooops! Didn't find anything in '\(searchTerm)'"
            case .Error:
                cell.activityIndicator.stopAnimating()
                placeholderTxt = "Something went wrong. Please try again."
            }
            cell.txtLabel.text = placeholderTxt
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: RID) as! ArtistTableViewCell
        let artist = artists[indexPath.row]
        cell.artist = artist
        cell.indexPath = indexPath
        cell.nameLabel.text = artist.artistName ?? "Unknown name"
        cell.descLabel.text = artist.primaryGenreName ?? "Unknown genre"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ArtistTableViewCell else { return }
        guard let artist = cell.artist else { return }
        pushAlbumsViewController(artist: artist)
    }
}

// MARK: - UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    // implementing this just to hide keyboard when users starts scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !autoScrolling else { return }
        searchBar.resignFirstResponder()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        autoScrolling = false
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        guard artists.count > 0 else { return }
        autoScrolling = true
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchTerm == "" {
            searchDone()
        } else {
            searchAndHandle()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchTerm = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if searchTerm == "" {
            convenience.showToast(toast: toast, withMessage: "Please enter a valid search text", view: view)
        } else {
            searchAndHandle()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDone()
    }
}
