//
//  TeacherApi.swift
//  DesafioComeia
//
//  Created by Kleyton Lopes on 05/01/17.
//  Copyright © 2017 com.desafio. All rights reserved.
//

import Foundation

class TeacherAPI: ApiConnection {
    typealias EntityType = Teacher
    struct apiKeys {
        static let className = "Professores"
        static let nome = "nome"
        static let curriculo = "curriculo"
        static let materia = "materia"
        static let nota = "nota"
        static let imagem = "imagem"
    }
    

}
