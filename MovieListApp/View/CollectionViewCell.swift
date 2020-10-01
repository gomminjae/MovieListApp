//
//  CollectionViewCell.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/09/30.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
