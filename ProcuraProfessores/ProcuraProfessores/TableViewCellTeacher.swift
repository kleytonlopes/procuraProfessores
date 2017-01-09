//
//  TableViewCellTeacher.swift
//  DesafioComeia
//
//  Created by Kleyton Lopes on 06/01/17.
//  Copyright © 2017 com.desafio. All rights reserved.
//

import UIKit
import FloatRatingView

class TableViewCellTeacher: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMateria: UILabel!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelNota: UILabel!

    @IBOutlet var floatRatingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelNota.layer.borderWidth = 1.5
        self.labelNota.roundCorner(value: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
