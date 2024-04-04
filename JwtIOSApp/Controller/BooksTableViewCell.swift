//
//  BooksTableViewCell.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile on 2024-04-04.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
