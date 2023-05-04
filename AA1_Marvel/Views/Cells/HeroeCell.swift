//
//  MovieCell.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 27/4/23.
//

import UIKit

class HeroeCell: UITableViewCell {

    
    @IBOutlet weak var mImage: MyImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var mDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
