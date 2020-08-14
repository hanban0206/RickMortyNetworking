//
//  FilterCell.swift
//  RickMortyNetworking
//
//  Created by Shawn Gee on 7/10/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    self.accessoryType = selected ? .checkmark : .none
}

}
