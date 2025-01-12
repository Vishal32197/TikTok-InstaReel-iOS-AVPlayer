//
//  CommentsTableViewCell.swift
//  TikTokDemo
//
//  Created by Bishal Ram on 15/12/24.
//

import UIKit
import Stevia

class CommentsTableViewCell: UITableViewCell {
    
    // MARK:- UI Components
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialisation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewLayout Setup
    private func setupUI() {
        self.backgroundColor = .clear
        self.subviews {
            profileImageView
            usernameLabel
            commentLabel
        }
        
        profileImageView.leading(12)
        profileImageView.CenterY == CenterY
        profileImageView.size(48)
        profileImageView.top(12)
        profileImageView.bottom(12)
        
        usernameLabel.Left == profileImageView.Right + 8
        usernameLabel.Top == profileImageView.Top + 2
        
        commentLabel.trailing(28)
        commentLabel.Left == profileImageView.Right + 8
        commentLabel.Top == usernameLabel.Bottom + 2
        commentLabel.Bottom == Bottom - 4
    }
    
    // MARK: Life Cycle Method
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
        commentLabel.text = nil
    }
    
    // MARK: Public Method
    func configure(with comment: Comment) {
        usernameLabel.text = comment.username
        commentLabel.text = comment.comment
        if let url = URL(string: comment.picURL) {
            profileImageView.loadImage(from: url)
        }
    }
}
