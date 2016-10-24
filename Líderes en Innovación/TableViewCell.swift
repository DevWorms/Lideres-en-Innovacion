//
//  TableViewCell.swift
//  Líderes en Innovación
//
//  Created by Emmanuel Valentín Granados López on 17/10/16.
//  Copyright © 2016 Emmanuel Valentín Granados López. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var textEvent: UILabel!
    @IBOutlet weak var textHorario: UILabel!
    @IBOutlet weak var btnCalendario: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
