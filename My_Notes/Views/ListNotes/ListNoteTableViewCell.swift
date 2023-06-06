//
//  ListNoteTableViewCell.swift
//  My_Notes
//
//  Created by apple on 07.06.2023.
//

import UIKit

class ListNoteTableViewCell: UITableViewCell {
    
    static let identifire = "ListNoteTableViewCell"

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func setUp(note:Note) {
        titleLbl.text = note.title
        descriptionLbl.text = note.desc
    }

}
