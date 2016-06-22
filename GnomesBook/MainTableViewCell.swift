//
//  MainTableViewCell.swift
//  GnomesBook
//
//  Created by Mario Martinez on 19/6/16.
//  Copyright © 2016 Brastlewark Town. All rights reserved.
//

import UIKit

// Se ha creado la clase para en el futuro se pueda personalizar más las celdas

class MainTableViewCell: UITableViewCell {

    @IBOutlet var Name: UILabel!
    
    func setNameText(name:String) {
        self.Name.text = name
    }
}
