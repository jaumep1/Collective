//
//  TrackCollectionViewCell.swift
//  Collective
//
//  Created by Jaume Pujadas on 8/24/22.
//

import UIKit
import SDWebImage

class AudioTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackCollectionViewCell"
    
    
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemPink
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 0
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .light)
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemBlue,
        .systemCyan,
        .systemGray,
        .systemMint,
        .systemTeal,
        .systemBrown,
        .systemYellow,
        .systemOrange,
        .systemGreen,
        .systemMint]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 10, y: contentView.width, width: contentView.width-20, height: contentView.height - contentView.width)
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.width)
    }
    
    func configure(with model: AudioTrackCollectionViewCellViewModel){
        label.text = model.title
        if (model.artworkURL != nil) {
            contentView.backgroundColor = .clear
        } else {
            contentView.backgroundColor = colors.randomElement()
        }
        imageView.sd_setImage(with: model.artworkURL, completed: nil)
        
    }
    
    func enableBorder() {
        imageView.layer.borderWidth = 5
    }
    
    func disableBorder() {
        imageView.layer.borderWidth = 0
    }
    
}
