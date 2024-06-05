//
//  MyTableViewCell.swift
//  A004IAI
//
//  Created by comsoft on 2024/06/05.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var salesAmount: UILabel!
    @IBOutlet weak var salesAccumulate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
