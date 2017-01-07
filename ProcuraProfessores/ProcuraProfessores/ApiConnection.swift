//
//  ApiConnection.swift
//  DesafioComeia
//
//  Created by Kleyton Lopes on 05/01/17.
//  Copyright © 2017 com.desafio. All rights reserved.
//
import Parse

protocol ApiConnection {
    associatedtype EntityType
}

extension ApiConnection{
    func requestList(withFilters filters: [String: Any], completionHandler: @escaping ([Teacher]?, Error?) -> Void) {
        
        var teachers = [Teacher]()
        let query = PFQuery(className:"Professores")
        if filters["prefix"] != nil {
            query.whereKey("nome", hasPrefix: filters["prefix"] as! String?)
        }
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil{
                for object in objects!{
                    let data = object
                    let teacher = Teacher()
                    teacher.name = data["nome"] as? String
                    teacher.curriculo = data["curriculo"] as? String
                    teacher.materia = data["materia"] as? String
                    teacher.nota = data["nota"] as? Float
                        
                    let imageFromParse = data["imagem"] as? PFFile
                        
                    imageFromParse?.getDataInBackground(block: { (imagem, error) in
                        let image: UIImage! = UIImage(data: imagem!)!
                        teacher.imagem = image
                        teachers.append(teacher)
                            
                        if teachers.count == objects?.count {
                            completionHandler(teachers, nil)
                        }
                    })
                        
                        
                    
                }
                
            }else{
                print("erro")
            }
        }


//        let urlToRequest = baseURL.appending(endpoint, with: parameters)
//        print(urlToRequest)
//        Alamofire.request(urlToRequest).responseArray { (response: DataResponse<[EntityType]>) in
//            switch response.result {
//            case .failure(let error):
//                completionHandler(nil, error)
//            case .success(let value):
//                completionHandler(value, nil)
//            }
//        }
    }
    
    func requestObject(withParameters parameters: [String:Any], completionHandler: @escaping (EntityType?, Error?) -> Void) {
        
    }
}
