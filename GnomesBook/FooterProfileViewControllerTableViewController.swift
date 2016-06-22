//
//  FooterProfileViewControllerTableViewController.swift
//  GnomesBook
//
//  Created by Mario Martinez on 21/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit

class FooterProfileViewControllerTableViewController: UITableViewController {
    
    var professions: Array<String> = []
    var friends: Array<String> = []

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FriendsSegue" {
            // reutilizamos la vista MaintTableViewController con el listado de amigos
            let friendsTableViewController : MainTableViewController = segue.destinationViewController as! MainTableViewController
            
            friendsTableViewController.alphabeticalNames = AppManager.sharedInstance.loadFriends(self.friends)
        } else if segue.identifier == "ProfessionsTableViewControllerSegue" {
            let professionsTableViewController : ProfessionsTableViewController = segue.destinationViewController as! ProfessionsTableViewController
            
            professionsTableViewController.professions = professions
        }
    }
}