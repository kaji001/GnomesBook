//
//  AlamofireExtesion.swift
//  GnomesBook
//
//  Created by Mario Martinez on 18/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit
import Alamofire

public enum BackendError: ErrorType {
    case Network(error: NSError)
    case DataSerialization(reason: String)
    case JSONSerialization(error: NSError)
    case ObjectSerialization(reason: String)
    case XMLSerialization(error: NSError)
}

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}
public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
    static func collectionFirstItem(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

// extension de la libreria de Alamofire para realizar la serialización de los datos recibidos por el JSON

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
        var collection = [Self]()
        
        if let representation = representation as? NSDictionary {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation.value) {
                    collection.append(item)
                }
            }
        }
        
        return collection
    }
    
    static func collectionFirstItem(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
        var collection = [Self]()
        
        if let representation = representation as? NSDictionary {
            if representation.count == 1 {
                let dic = representation[representation.allKeys[0] as! NSCopying] as! NSArray
                
                for itemRepresentation in dic {
                    
                    if let item = Self(response: response, representation: itemRepresentation) {
                        collection.append(item)
                    }
                }
            }
        }
        
        return collection
    }
}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    return .Failure(. ObjectSerialization(reason: "Response collection could not be serialized due to nil response"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public func responseFirstItemCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collectionFirstItem(response: response, representation: value))
                } else {
                    return .Failure(. ObjectSerialization(reason: "Response collection could not be serialized due to nil response"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

