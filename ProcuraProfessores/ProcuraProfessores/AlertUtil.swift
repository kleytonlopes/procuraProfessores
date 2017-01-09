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
    //função que exibe um alerta com o botão OK
    static func presentOKAlert(withTitle title: String,andMessage message: String, originController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Project.Localizable.title.buttonOK.rawValue, style: .default, handler: nil)
        alert.addAction(okAction)
        originController.present(alert, animated: true, completion: nil)
    }
    
    
}
