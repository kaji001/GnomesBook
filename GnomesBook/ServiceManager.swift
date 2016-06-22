//
//  ServiceManager.swift
//  GnomesBook
//
//  Created by Mario Martinez on 18/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit
import Alamofire

class ServiceManager {
    private let urlService : String = "https://raw.githubusercontent.com/AXA-GROUP-SOLUTIONS/mobilefactory-test/master/data.json"
    
    private let maxIntents : Int = 3
    
    private var intents : Int = 0
    
    func getGnomesData(completion:([Gnome], String?) -> Void) {
        Alamofire.request(.GET, urlService)
            .validate()
            .responseFirstItemCollection { (response: Response<[Gnome], BackendError>) in
                
                if response.result.isFailure || !response.result.isSuccess {
                    
                    
                    if self.intents < 3 {
                        self.intents += 1
                        sleep(3)
                        
                        self.getGnomesData(completion)
                    } else {
                        self.intents = 0
                        // mensaje de error
                        // response.result.error.debugDescription
                        completion([], "Error de conexión")
                    }
                    
                } else {
                    self.intents = 0
                    completion(response.result.value!, nil)
                }
        }
    }
}