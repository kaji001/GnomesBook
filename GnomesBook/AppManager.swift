//
//  AppManager.swift
//  GnomesBook
//
//  Created by Mario Martinez on 18/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit

class AppManager {
    
    static let sharedInstance = AppManager()
    
    private let initialViewControllerClass = LoadingViewController.self
    private let serviceManager : ServiceManager
    
    private var dictionaryGnome : Dictionary<String, Gnome>
    var alphabeticalDictionaryGnome : Dictionary<String, [Gnome]>
    
    private init() {
        self.serviceManager = ServiceManager()
        self.dictionaryGnome = Dictionary<String, Gnome>()
        self.alphabeticalDictionaryGnome = Dictionary<String, [Gnome]>()
    }
    
    // Inicar aplicación
    func start(initialViewController : UIViewController?) throws {

        // Comprobación si el viewcontroller de inicio del Storyboard
        if initialViewController?.isKindOfClass(initialViewControllerClass) == false {
            throw NSError(domain: "AppManager.start.ErrorStoryBoard", code: 0, userInfo: nil)
        }
        
        loadData(initialViewController as? LoadingViewController)
    }
    
    // Carga amigos a partir de un array de strings
    func loadFriends(friends: [String]) -> Dictionary<String, [Gnome]> {
        var gnomeFriends = [Gnome]()
        for friend in friends {
            gnomeFriends.append(dictionaryGnome[friend]!)
        }
        
        return alphabeticalDictionaryGnome(gnomeFriends)
    }
    
    // carga inicial de datos
    private func loadData(viewController:LoadingViewController?) {
        self.serviceManager.getGnomesData({(arrayGnome:[Gnome], error:String?) -> Void in
            
            if error != nil {
                viewController?.stopLoading()
                
                let alertController = UIAlertController(title: "Alerta", message: error, preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "Reconectar", style: .Default) { (action) in
                    viewController?.startLoading()
                    self.loadData(viewController)
                }
                
                alertController.addAction(OKAction)
                
                viewController!.presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
            
            let arrayGnomeSort = arrayGnome.sort({
                $0.fullName < $1.fullName
            })
            
            for item in arrayGnomeSort {
                // dictionaryGnome
                self.dictionaryGnome[item.fullName] = item
                
                // alphabeticalDictionaryGnome
                let firstLetter = String(item.name[item.name.startIndex])
                
                if self.alphabeticalDictionaryGnome[firstLetter] == nil {
                   self.alphabeticalDictionaryGnome[firstLetter] = Array()
                }
                
                self.alphabeticalDictionaryGnome[firstLetter]?.append(item)
            }
            
            viewController?.stopLoading()
            viewController?.nexViewController()
        })
    }
    
    // Creación de un dicionario indexado por letra inicial
    private func alphabeticalDictionaryGnome(arrayGnome:[Gnome]) -> Dictionary<String, [Gnome]> {
        var temporalAlphabeticalDictionaryGnome = Dictionary<String, [Gnome]>()
        
        let arrayGnomeSort = arrayGnome.sort({
            $0.fullName < $1.fullName
        })
        
        for item in arrayGnomeSort {
            let firstLetter = String(item.name[item.name.startIndex])
            
            if temporalAlphabeticalDictionaryGnome[firstLetter] == nil {
                temporalAlphabeticalDictionaryGnome[firstLetter] = Array()
            }
            
            temporalAlphabeticalDictionaryGnome[firstLetter]?.append(item)
        }
        
        return temporalAlphabeticalDictionaryGnome
    }
}
