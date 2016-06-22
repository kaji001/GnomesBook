//
//  MainTableViewController.swift
//  GnomesBook
//
//  Created by Mario Martinez on 19/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UISearchBarDelegate {
    
    let alphabet : Array<String> = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var sections : Array<String>
    var sectionsFiltered : Array<String>
    var alphabeticalNames : Dictionary<String, [Gnome]>
    var alphabeticalNamesFiltered : Dictionary<String, [Gnome]>
    
    var searchActive : Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        sections = alphabet
        sectionsFiltered = alphabet
        alphabeticalNames = AppManager.sharedInstance.alphabeticalDictionaryGnome
        alphabeticalNamesFiltered = alphabeticalNames
        
        super.init(coder:aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        searchActive = false
        reloadSections()
    }
    
    private func reloadSections() {
        sections = alphabet
        sectionsFiltered = alphabet
        
        for section in alphabet {
            if alphabeticalNamesFiltered[section] == nil {
                sectionsFiltered.removeAtIndex(sectionsFiltered.indexOf(section)!)
            }
            
            if alphabeticalNames[section] == nil {
                sections.removeAtIndex(sections.indexOf(section)!)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchActive ? sectionsFiltered.count : sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return searchActive ? self.sectionsFiltered[section] : self.sections[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arraySection: [Gnome] = searchActive ? alphabeticalNamesFiltered[sectionsFiltered[section]]! : alphabeticalNames[sections[section]]!
        
        return arraySection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : MainTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as! MainTableViewCell
        
        let gnomeItem = getGnomeTableView(indexPath)
        
        cell.setNameText(gnomeItem.name + ", " + gnomeItem.surname)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let gnome : Gnome = getGnomeTableView(indexPath)
        
        self.performSegueWithIdentifier("ProfileViewControllerSegue", sender: gnome)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return tableView.sectionHeaderHeight
        }
        return 0
    }
    
    func getGnomeTableView(indexPath: NSIndexPath) -> Gnome {
        let arrayNamesSection : [Gnome]
        
        if searchActive {
            arrayNamesSection = alphabeticalNamesFiltered[sectionsFiltered[indexPath.section]]! as [Gnome]
        } else {
            arrayNamesSection = alphabeticalNames[sections[indexPath.section]]! as [Gnome]
        }
        
        return arrayNamesSection[indexPath.row]
    }
    
    // MARK: - UISearchBarDelegate Delegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
        alphabeticalNamesFiltered = alphabeticalNames
        sectionsFiltered = sections
    }
    
    func searchBarTextDidShoudEditing(searchBar: UISearchBar) {
        searchActive = true
        alphabeticalNamesFiltered = alphabeticalNames
        sectionsFiltered = sections
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarTextDidShoudEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        self.tableView.reloadData()
    }
    
    
    // MARK: - UISearchResultsUpdating Delegate
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        alphabeticalNamesFiltered = alphabeticalNames
        sectionsFiltered = sections
        
        if !searchString.isEmpty {
            
            for (key, value) in alphabeticalNamesFiltered {
                let array: [Gnome] = value.filter(){
                    return $0.fullName.uppercaseString.containsString(searchString.uppercaseString)
                }
                
                if array.count == 0 {
                    alphabeticalNamesFiltered.removeValueForKey(key)
                } else {
                    alphabeticalNamesFiltered[key] = array
                }
            }
        }
            
        reloadSections()
        self.tableView.reloadData()
        
        return true
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProfileViewControllerSegue" {
            if let nextViewController : ProfileViewController = segue.destinationViewController as? ProfileViewController {
                nextViewController.gnome = sender as! Gnome
            }
        }
    }
}