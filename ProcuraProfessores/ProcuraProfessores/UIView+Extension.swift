//
//  View+Extension.swift
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 08/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: Arredondar bordas de uma view
    func roundCorner(value : CGFloat){
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    //MARK: Arredondar bordas de uma view até virar circulo
    func roundToCircle(){
        self.layer.cornerRadius = self.bounds.width/2
        self.layer.masksToBounds = true
    }
}
