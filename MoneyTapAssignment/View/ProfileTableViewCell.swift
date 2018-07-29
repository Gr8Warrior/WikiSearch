//
//  ProfileTableViewCell.swift
//  MoneyTapAssignment
//
//  Created by Shailendra Suriyal on 28/07/18.
//  Copyright © 2018 Shailendra Suriyal. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
   
    @IBOutlet weak var profileTitle: UILabel!
    
    @IBOutlet weak var profileDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
