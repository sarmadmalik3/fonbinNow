//
//  Menu_TableViewCell.swift
//  ZakatCalculator
//
//  Created by Sarmad Ishfaq on 21/08/2019.
//  Copyright © 2019 circularbyte. All rights reserved.
//

import UIKit

class Menu_TableViewCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet var lblStone: UILabel!
        override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.lblStone.font = lblStone.font.withSize(25)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
