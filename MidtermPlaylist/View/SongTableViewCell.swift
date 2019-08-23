//
//  SongTableViewCell.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func clickLikeButton(_ sender: UIButton) {
        handler?(self)
    }
    
    var handler: ((SongTableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(name: String, imageString: String, isLike: Bool) {
        songImageView.loadImage(urlString: imageString)
        songNameLabel.text = name
        updateIslike(isLike: isLike)
    }
    
    func updateIslike(isLike: Bool) {
        if isLike {
            likeButton.setImage(UIImage.asset(ImageAsset.heartFill)?.withRenderingMode(.alwaysTemplate), for: .normal)
            likeButton.imageView?.tintColor = UIColor.red
            
        } else {
            likeButton.setImage(UIImage.asset(ImageAsset.heart)?.withRenderingMode(.alwaysTemplate), for: .normal)
            likeButton.imageView?.tintColor = UIColor.black
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
