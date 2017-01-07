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
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelMateria: UILabel!
    @IBOutlet var imageViewPhoto: UIImageView!
    @IBOutlet var labelNota: UILabel!

    @IBOutlet var floatRatingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
