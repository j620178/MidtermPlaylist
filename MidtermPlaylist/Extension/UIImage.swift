//
//  UIImage.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

enum ImageAsset: String {
    
    case heart
    case heartFill

}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
    
}
