//
//  FeedCollectionViewCell.swift
//  Collective
//
//  Created by Jaume Pujadas on 11/6/22.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeedCollectionViewCell"
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "TITLE"
        return label
    }()
    
    private let author: UILabel = {
        let label = UILabel()
        label.text = "AUTHOR"
        return label
    }()
    
    private let artist: UILabel = {
        let label = UILabel()
        label.text = "ARTIST"
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(coverImage)
        contentView.addSubview(title)
        contentView.addSubview(author)
        contentView.addSubview(artist)
        contentView.layer.borderWidth = 5
        contentView.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRect(x: 5, y: contentView.frame.size.height-50, width: 2*contentView.frame.size.width/5, height: 50)
        author.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width, height: 50)

        artist.frame = CGRect(x: 3*contentView.frame.size.width/5 , y: contentView.frame.size.height-50, width: 2*(contentView.frame.size.width/5) - 5, height: 50)
        
        coverImage.frame = CGRect(x: 5, y: 55, width: contentView.frame.size.width-10, height: contentView.frame.size.height-105)
     }
    
    func configure(with model: FeedCellViewModel){
        title.text = model.title
        author.text = model.author
        artist.text = model.artist
        coverImage.sd_setImage(with: model.artworkURL, completed: nil)
    }
}
