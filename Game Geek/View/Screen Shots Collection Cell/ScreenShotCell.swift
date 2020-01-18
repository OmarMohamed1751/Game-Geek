//
//  ScreenShotCell.swift
//  Game Geek
//
//  Created by Omar Mohamed on 1/18/20.
//  Copyright © 2020 Omar Mohamed. All rights reserved.
//

import UIKit
import Kingfisher

class ScreenShotCell: UICollectionViewCell {
    
    @IBOutlet weak var screenshotImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        screenshotImage.layer.cornerRadius = 5
    }
    
    func attachScreenshots(screenshot: ShortScreenshot) {
        if let screenshotURL = screenshot.image {
            self.screenshotImage.kf.setImage(with: URL(string: screenshotURL), placeholder: UIImage.init(systemName: "camera.fill"))
        }
    }

}
