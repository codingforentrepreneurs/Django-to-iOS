//
//  ProjectTableCell.swift
//  srvup
//
//  Created by Justin Mitchel on 6/16/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class ProjectTableCell: UITableViewCell {

    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
