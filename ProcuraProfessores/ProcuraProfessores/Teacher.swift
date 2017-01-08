//
//  Teacher.swift
//  DesafioComeia
//
//  Created by Kleyton Lopes on 05/01/17.
//  Copyright © 2017 com.desafio. All rights reserved.
//
import UIKit
import Parse

class Teacher : ParseConversible {
    var objectID: String!
    var name: String!
    var curriculo: String!
    var materia: String!
    var imagem: UIImage?
    var nota: Float!
    
    convenience required init(with pFObject: PFObject) {
        self.init()
        self.name = pFObject[TeacherAPI.apiKeys.nome] as? String
        self.curriculo = pFObject[TeacherAPI.apiKeys.curriculo] as? String
        self.materia = pFObject[TeacherAPI.apiKeys.materia] as? String
        self.nota = pFObject[TeacherAPI.apiKeys.nota] as? Float
    }
}


