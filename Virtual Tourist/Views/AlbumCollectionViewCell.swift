//
//  AlbumCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Vivekananda Cherukuri on 05/12/2017.
//  Copyright © 2017 Flying Fish Studios. All rights reserved.
//

import Foundation
import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        if(photoImageView.image == nil)
        {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            photoImageView.image = UIImage(named:"placeholder")
        }
    }

}
