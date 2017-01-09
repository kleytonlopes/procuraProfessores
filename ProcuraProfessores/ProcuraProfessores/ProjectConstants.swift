//
//  ProjectConstants.swift
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 09/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.
//

enum Project {
    // Localizable Strings
    enum Localizable {
        // Titles
        enum title: String {
            case curriculo = "title_alert_curriculo"
            case error = "title_alert_error"
        }
        // Messages
        enum message: String {
            case noResults = "message_no_results"
        }
    }
    // Parse
    enum ParseConfiguration: String {
        case applicationId = "SU0myMIe1AUitLKar0mum8My8RbQ87lEaRjjKDgh"
        case clientKey = "Fttez4PLMZOJbNty4lfT8QYcSj28worpNdoYxicO"
        case server = "https://parseapi.back4app.com/"
    }
}
