//
//  ProfileViewController.swift
//  GnomesBook
//
//  Created by Mario Martinez on 20/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit
import Haneke

class ProfileViewController: UIViewController {
    
    var gnome: Gnome
    
    @IBOutlet var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var hairColor: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        gnome = Gnome()
        
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        name.text = gnome.name
        surname.text = gnome.surname
        age.text = String(gnome.age)
        weight.text = String(gnome.weight)
        height.text = String(gnome.height)
        hairColor.text = gnome.hairColor
        
        imageView.layer.cornerRadius = 58.0
        imageView.clipsToBounds = true
        
        let url : NSURL = NSURL(string: gnome.thumbnail)!
        imageView.hnk_setImageFromURL(url)
        
        super.viewWillAppear(animated)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "FooterProfileViewControllerTableViewControllerSegue" {
            // reutilizamos la vista MaintTableViewController con el listado de amigos
            let footerTableViewController : FooterProfileViewControllerTableViewController = segue.destinationViewController as! FooterProfileViewControllerTableViewController
            
            footerTableViewController.friends = self.gnome.friends
            footerTableViewController.professions = self.gnome.professions
        }
    }
}
