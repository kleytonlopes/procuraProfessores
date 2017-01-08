//
//  AlertUtil.swift
//
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 07/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.

import Foundation
import UIKit

final class AlertUtil {
    
    static func presentOKAlert(withTitle title: String,andMessage message: String, originController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        originController.present(alert, animated: true, completion: nil)
    }
    
    
}
