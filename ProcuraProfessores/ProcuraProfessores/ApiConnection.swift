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
private let keyImage = "imagem"
extension ApiConnection where EntityType: ParseConversible {
    
    /** Função para fazer o Download de uma imagem de um PFObject
     */
    func requestImage(withPFObject pFObject: PFObject, completionHandler: @escaping (UIImage?, Error?) -> Void){
        let imageFromParse = pFObject[keyImage] as? PFFile
        imageFromParse?.getDataInBackground(block: { (imagem, error) in
            if error == nil{
                let image: UIImage! = UIImage(data: imagem!)!
                completionHandler(image, error)
            }
            else{
                completionHandler(nil, error)
            }
        })
    }
    
    /** Função para fazer a requisição de uma lista de objetos que tem como prefixo uma palavra determinada.
     */
    func requestListOfObjects(withPrefix prefix: String,key: String , className: String ,completionHandler: @escaping ([EntityType]?,[PFObject]?, Error?) -> Void) {
        
        var entities = [EntityType]()
        let query = PFQuery(className:className)
        query.whereKey(key, matchesRegex: "^\(prefix)", modifiers: "i")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil{
                for data in objects!{
                    let entity = EntityType(with: data)
                    entities.append(entity)
                }
                completionHandler(entities, objects! ,nil)
                
            }else{
                completionHandler(nil, nil ,error)
            }
        }
    }
}
