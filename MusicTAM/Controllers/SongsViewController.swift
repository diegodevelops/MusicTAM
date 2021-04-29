//
//  SongsViewController.swift
//  MusicTAM
//
//  Created by Diego A. Perez Pares on 4/29/21.
//

import UIKit


class SongsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    // MARK: - Properties
    private let convenience = Convenience.sharedInstance()
    private let RID = "SongCollecionViewCell"
    private var albums = [Album]()
    private var searchMode: SearchMode = .Active
    private let imgDownloadHelper = ImageDownloadHelper()
    private let toast = UILabel()
    private var songs = [Song]()
    
    /// through push or present
    var album: Album!
    
    /// API helpers
    private var dataSource: ArtistDataSource!
    private var repo: RestRepository!
    private var webService: WebService!
    private var webServiceUrlBuilder: WebServiceURLProviderBuilder!
    
    // flowLayout
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    fileprivate var itemsPerRow: CGFloat = 2.0
    fileprivate var paddingSpace: CGFloat = 24
    
    // To check for reference cycles
    deinit {
        print("\n\n deinit SongsViewController \n\n")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        searchAndHandle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // updating nav bar here in case it was modified on other pushed view controllers
        convenience.updatenNavbarTitle(selfController: self, withTitle: album.collectionName ?? "", fontName: "Menlo-Bold", fontSize: 17, fontColor: .black)
    }
    
    // this will also update items per row in case we're in an iPad and it rotates
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpFlowLayout()
    }
    
    // MARK: - only once
    private func setUp() {
        // collectionView
        collectionView.register(SongCollecionViewCell.self, forCellWithReuseIdentifier: RID)
        // toast
        convenience.createToast(toast: toast, view: view, withBackgroundColor: UIColor.black.withAlphaComponent(0.8), fontName: "Helvetica-Bold", fontSize: 14, fontColor: UIColor.white)
        // API helpers
        webService = WebService()
        repo = RestRepository(webService: webService)
        webServiceUrlBuilder = WebServiceURLProviderBuilder()
        dataSource = DataSource(repository: repo, webServiceURLProvider: webServiceUrlBuilder.getProvider(for: Compilation.environment))
        // label text
        noResultsLabel.text = "Searching for songs in \(album.collectionName ?? "Unknown name")..."
    }
    private func setUpFlowLayout() {
        // in case we're in an iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            itemsPerRow = 4.0
            paddingSpace = 40
        }
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let itemSize = CGSize(width: widthPerItem, height: widthPerItem*1.5)
        flowLayout.sectionInset = sectionInsets
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
    }
    
    // MARK: - search helpers
    private func searchAndHandle() {
        dataSource.getSongs(collectionId: album.collectionId ?? 0, needsLoader: nil, completion: {
            [weak self] songResponse in
            if let songResponse = songResponse,
               let firstSongResponse = songResponse.first,
               let songs = firstSongResponse.results {
                self?.searchMode = .Success
                self?.songs = songs
                performUIUpdatesOnMain {
                    self?.collectionView.reloadData()
                    self?.noResultsLabel.isHidden = true
                }
            } else {
                self?.searchMode = .Error
                performUIUpdatesOnMain { self?.showNoResultsLabel() }
            }
        }, failure: {
            [weak self] errorMsg in
            self?.searchMode = .Error
            performUIUpdatesOnMain { self?.showNoResultsLabel() }
        })
    }
    private func showNoResultsLabel() {
        noResultsLabel.text = "Didn't find \(album.collectionName)'s songs"
        noResultsLabel.isHidden = false
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SongsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RID, for: indexPath) as! SongCollecionViewCell
        let song = songs[indexPath.row]
        cell.song = song
        cell.tLabel.text = song.trackName ?? "Unknown name"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // handle image loading here in case images from re-used cells overlap
        if let cell = cell as? SongCollecionViewCell {
            // this too we must update
            cell.tLabel.textColor = (cell.song?.trackName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") == "" ? .lightGray : .black
            // timestampString can be a unique text that
            // we can use to track the image in the cache
            let timestampString = (cell.song?.trackName ?? "").trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "_").folding(options: .diacriticInsensitive, locale: .current)
            imgDownloadHelper.loadMedia(urlString: cell.song?.artworkUrl100 ?? "", timestampString: timestampString)  {
                image in
                performUIUpdatesOnMain {
                    cell.updateImageIfNeeded(image: image)
                }
            }
        }
    }
}
