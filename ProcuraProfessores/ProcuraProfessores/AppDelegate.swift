//
//  AppDelegate.swift
//  ProcuraProfessores
//
//  Created by Kleyton Lopes on 07/01/17.
//  Copyright © 2017 br.com.desafioColmeia. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initParse()
        return true
    }
    
    func initParse(){
        let configuration = ParseClientConfiguration {
            $0.applicationId = Project.ParseConfiguration.applicationId.rawValue
            $0.clientKey = Project.ParseConfiguration.clientKey.rawValue
            $0.server = Project.ParseConfiguration.server.rawValue
        }
        Parse.initialize(with: configuration)
    }
}

