//
//  AboutUsTableViewCell.swift
//  ZakatCalculator
//
//  Created by Sarmad Ishfaq on 21/08/2019.
//  Copyright © 2019 circularbyte. All rights reserved.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {

    @IBOutlet var lblname: UILabel!
    @IBOutlet var imgLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.lblname.font = lblname.font.withSize(25)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
