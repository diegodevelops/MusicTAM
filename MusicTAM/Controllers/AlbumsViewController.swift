//
//  AlbumsViewController.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!    
    
    // MARK: - Properties
    private let convenience = Convenience.sharedInstance()
    private let RID = "ArtistTableViewCell"
    private let RID_PLACEHOLDER = "PlaceholderTableViewCell"
    private let SID = "SongsViewController"
    private var albums = [Album]()
    private var searchMode: SearchMode = .Active
    private let imgDownloadHelper = ImageDownloadHelper()
    private let toast = UILabel()
    
    /// through push or present
    var artist: Artist!
    
    /// API helpers
    private var dataSource: ArtistDataSource!
    private var repo: RestRepository!
    private var webService: WebService!
    private var webServiceUrlBuilder: WebServiceURLProviderBuilder!
    
    // To check for reference cycles
    deinit {
        print("\n\n deinit AlbumsViewController \n\n")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        searchAndHandle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // updating nav bar here in case it was modified on other pushed view controllers
        convenience.updatenNavbarTitle(selfController: self, withTitle: artist.artistName ?? "", fontName: "Menlo-Bold", fontSize: 17, fontColor: .black)
    }
    
    // MARK: -setUp
    private func setUp() {
        // tableView
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: RID)
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
    private func searchAndHandle() {
        dataSource.getAlbums(amgArtistId: artist.amgArtistId ?? 0, needsLoader: nil, completion: {
            [weak self] albumResponse in
            if let albumResponse = albumResponse,
               let firstAlbumResponse = albumResponse.first,
               let albums = firstAlbumResponse.results {
                self?.searchMode = .Success
                self?.albums = albums
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
    private func pushAlbumsViewController(album: Album) {
        let vc = storyboard?.instantiateViewController(identifier: SID) as! SongsViewController
        vc.album = album
        navigationItem.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count == 0 ? 1 : albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if albums.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RID_PLACEHOLDER) as! PlaceholderTableViewCell
            var placeholderTxt = ""
            switch searchMode {
            case .Home:
                cell.activityIndicator.stopAnimating()
                placeholderTxt = "Didn't find \(artist.artistName ?? "")'s albums"
            case .Active:
                cell.activityIndicator.startAnimating()
                placeholderTxt = "Searching for \(artist.artistName ?? "")'s albums..."
            case .Success:
                cell.activityIndicator.stopAnimating()
                placeholderTxt = "Didn't find \(artist.artistName ?? "")'s albums"
            case .Error:
                cell.activityIndicator.stopAnimating()
                placeholderTxt = "Something went wrong!"
            }
            cell.txtLabel.text = placeholderTxt
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: RID) as! AlbumTableViewCell
        let album = albums[indexPath.row]
        cell.album = album
        cell.indexPath = indexPath
        cell.nameLabel.text = album.collectionName ?? "Unknown name"
        cell.descLabel.text = album.releaseDate ?? "Unknown genre"
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // handle image loading here in case images from re-used cells overlap
        if let cell = cell as? AlbumTableViewCell {
            // timestampString can be a unique text that
            // we can use to track the image in the cache
            let timestampString = (cell.album?.collectionName ?? "").trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "_").folding(options: .diacriticInsensitive, locale: .current)
            imgDownloadHelper.loadMedia(urlString: cell.album?.artworkUrl60 ?? "", timestampString: timestampString)  {
                image in
                performUIUpdatesOnMain {
                    cell.updateImageIfNeeded(image: image)
                }
            }
         }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? AlbumTableViewCell else { return }
        guard let album = cell.album else { return }
        pushAlbumsViewController(album: album)
    }
}
