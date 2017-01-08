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

extension ApiConnection where EntityType: ParseConversible {
    
    func requestImage(withPFObject pFObject: PFObject, completionHandler: @escaping (UIImage, Error?) -> Void){
        let imageFromParse = pFObject["imagem"] as? PFFile
        imageFromParse?.getDataInBackground(block: { (imagem, error) in
            let image: UIImage! = UIImage(data: imagem!)!
            completionHandler(image, error)
        })
    }
    
    func requestList(withFilters filters: [String: Any], completionHandler: @escaping ([EntityType]?,[PFObject], Error?) -> Void) {
        
        var entities = [EntityType]()
        let query = PFQuery(className:"Professores")
        if filters["prefix"] != nil {
            query.whereKey("nome", matchesRegex: "^\(filters["prefix"]!)", modifiers: "i")
        }
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil{
                for data in objects!{
                    let entity = EntityType(with: data)
                    entities.append(entity)
                }
                completionHandler(entities, objects! ,nil)
                
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
