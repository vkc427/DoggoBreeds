//
//  DogViewTableViewCell.swift
//  DoggoBreeds
//
//  Created by Karthik Vadlamudi on 5/18/21.
//

import UIKit

class DogViewTableViewCell: UITableViewCell {
    @IBOutlet weak var lblBreedName: UILabel!
    @IBOutlet weak var imgBreed: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
