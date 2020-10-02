//
//  DirectorInfoCell.swift
//  MovieListApp
//
//  Created by 권민재 on 2020/10/02.
//

import UIKit

class DirectorInfoCell: UITableViewCell {
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
