//
//  VideoPlayerViewController.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

import UIKit
import Stevia
import RxSwift

class VideoPlayerViewController: UIViewController {
    
    // MARK: UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.register(VideoPlayerCollectionViewCell.self, forCellWithReuseIdentifier: VideoPlayerCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: Properties
    private var viewModel: VideoPlayerViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    // MARK: Initialisation
    init(viewModel: VideoPlayerViewModelProtocol = VideoPlayerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupCollectionView()
        bindViewModel()
        viewModel.loadVideosAndComments()
    }
    
    // MARK: Private Methods
    private func bindViewModel() {
        viewModel.videoDataSource
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        view.subviews {
            collectionView
        }
    }
  }

extension VideoPlayerViewController: UICollectionViewDataSource, UICollectionViewDelegate, VideoPlayerDelegate {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.videoDataSource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoPlayerCollectionViewCell.identifier, for: indexPath) as! VideoPlayerCollectionViewCell
        cell.delegate = self
        cell.comments = viewModel.comments.value
        cell.configure(with: viewModel.videoDataSource.value[indexPath.row])
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        playVisibleCell()
    }
    
    func playVisibleCell() {
        let visibleCells = collectionView.visibleCells.compactMap { $0 as? VideoPlayerCollectionViewCell }
        for cell in visibleCells {
            let cellRect = collectionView.convert(cell.frame, to: view)
            let isFullyVisible = view.bounds.contains(cellRect)
            
            if isFullyVisible {
                cell.videoPlayer.play()
            } else {
                cell.videoPlayer.pause()
            }
        }
    }
    
    // MARK: VideoPlayerDelegate
    func didCommentsScrolled(_isScrolled: Bool) {
        collectionView.isScrollEnabled = _isScrolled
    }
}
