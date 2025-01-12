//
//  VideoPlayerCollectionViewCell.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

import UIKit
import Stevia

protocol VideoPlayerDelegate: AnyObject {
    func didCommentsScrolled(_isScrolled: Bool)
}

class VideoPlayerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VideoCell"
    
    // MARK: UI Components
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        return imageView
    }()
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var tableViewFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let commentBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private let viewersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    private lazy var commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Comment"
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 14)
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
        textField.leftViewMode = .always
        return textField
    }()
    private let sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        return button
    }()
    private var doubleTapGesture: UITapGestureRecognizer!
    let videoPlayer = AVVideoPlayer()
    
    // MARK: Properties
    weak var delegate: VideoPlayerDelegate?
    var comments: [Comment]? {
        didSet {
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
        }
    }
    
    // MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayer()
        setupOverlayUI()
        addTapGesture()
        setupDoubleTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        videoPlayer.player?.pause()
        videoPlayer.playerLayer?.player = nil
    }
    
    // MARK: ViewLayout Setup
    private func setupOverlayUI() {
        
        contentView.subviews {
            overlayView
            commentBoxView
        }
        
        overlayView.subviews {
            thumbnailImageView
            usernameLabel
            profileImageView
            likesLabel
            viewersLabel
        }
        
        overlayView.fillContainer()
        
        profileImageView.Top == overlayView.Top + Constants.overlayViewTopConstant
        profileImageView.size(Constants.imageViewSize)
        profileImageView.Leading == overlayView.Leading + Constants.leadingConstaint
        
        usernameLabel.Top == profileImageView.Top + Constants.verticalSpacing
        usernameLabel.Left == profileImageView.Right + Constants.horizontalSpacing
        
        likesLabel.Top == usernameLabel.Bottom + Constants.verticalSpacing
        likesLabel.Leading == usernameLabel.Leading
        
        thumbnailImageView.Top == overlayView.Top
        thumbnailImageView.fillHorizontally()
        thumbnailImageView.Bottom == overlayView.Bottom
        
        viewersLabel.Right == overlayView.Right - Constants.rightSpacing
        viewersLabel.CenterY == usernameLabel.CenterY
        
        let tableHeight: CGFloat = 300
        commentBoxView.frame = CGRect(x: 16, y: contentView.frame.height - tableHeight - 16,
                                      width: contentView.frame.width - 32,
                                      height: tableHeight)
        
        commentBoxView.translatesAutoresizingMaskIntoConstraints = false
        
        commentBoxView.subviews {
            commentsTableView
        }
        
        commentsTableView.frame = CGRect(x: 0, y: 0, width: commentBoxView.frame.width, height: commentBoxView.frame.height)
    }
    
    private func setupPlayer() {
        videoPlayer.playerLayer?.frame = contentView.bounds
        overlayView.addSubview(videoPlayer)
    }
    
    private func setupDoubleTapGesture() {
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func handleDoubleTap() {
        showFloatingHeart()
    }
    
    private func showFloatingHeart() {
        let heartImageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        heartImageView.tintColor = .red
        heartImageView.alpha = 0
        heartImageView.frame = CGRect(x: contentView.center.x - 25, y: contentView.center.y - 25, width: 50, height: 50)
        contentView.addSubview(heartImageView)
        
        UIView.animate(
            withDuration: 0.6,
            animations: {
                heartImageView.alpha = 1
                heartImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.6,
                    animations: {
                        heartImageView.alpha = 0
                        heartImageView.transform = CGAffineTransform(translationX: 0, y: -100)
                    },
                    completion: { _ in
                        heartImageView.removeFromSuperview()
                    }
                )
            }
        )
    }
    
    private func getFooterView() -> UIView {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        
        footerView.addSubview(commentTextField)
        footerView.addSubview(sendButton)
        
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentTextField.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            commentTextField.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        return footerView
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleVideoTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func sendComment() {
        guard let commentText = commentTextField.text, !commentText.isEmpty else {
            return
        }
        
        comments?.append(Comment(id: 120, username: "User1", picURL: "https://fastly.picsum.photos/id/474/200/200.jpg?hmac=X5gJb746aYb_1-VdQG2Cti4XcHC10gwaOfRGfs6fTNk", comment: commentText))
        commentTextField.text = ""
        DispatchQueue.main.async {
            self.commentsTableView.reloadData()
        }
    }
    
    @objc private func handleVideoTap() {
        videoPlayer.togglePlayPause()
    }
    
    // MARK: Public Methods
    func configure(with video: Video) {
        usernameLabel.text = video.username
        likesLabel.text = "❤️ \(video.likes)"
        videoPlayer.delegate = self
        videoPlayer.configure(with: video.video)
        viewersLabel.text = "\(video.viewers)"
        
        if let profileURL = URL(string: video.profilePicURL) {
            profileImageView.loadImage(from: profileURL)
        }
        
        if let thumbnailURL = URL(string: video.thumbnail) {
            thumbnailImageView.loadImage(from: thumbnailURL)
        }
        
        if let profileImageViewURL = URL(string: video.profilePicURL) {
            profileImageView.loadImage(from: profileImageViewURL)
        }
    }
    
    // MARK: Constants
    private enum Constants {
        static let overlayViewTopConstant: CGFloat = 54
        static let leadingConstaint: CGFloat = 12
        static let imageViewSize: CGFloat = 48
        static let horizontalSpacing: CGFloat = 4
        static let verticalSpacing: CGFloat = 2
        static let rightSpacing: CGFloat = 20
    }
}

extension VideoPlayerCollectionViewCell: UITableViewDataSource, UITableViewDelegate, CustomVideoPlayerDelegate {
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        getFooterView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == commentsTableView {
            delegate?.didCommentsScrolled(_isScrolled: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == commentsTableView {
            delegate?.didCommentsScrolled(_isScrolled: true)
        }
    }
    
    // MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell else {
            return UITableViewCell()
        }
        guard let comments else { return UITableViewCell() }
        cell.configure(with: comments[indexPath.row])
        return cell
    }
    
    // MARK: CustomVideoPlayerDelegate
    func didStartPlaying() {
        thumbnailImageView.isHidden = true
    }
    
    func didPausePlaying() {
        //
    }
}
