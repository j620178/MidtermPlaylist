//
//  Kingfisher.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.kf.setImage(with: url)
    }
}
