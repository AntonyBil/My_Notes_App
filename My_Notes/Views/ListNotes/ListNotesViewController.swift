//
//  ListNotesViewController.swift
//  My_Notes
//
//  Created by apple on 07.06.2023.
//

import UIKit

class ListNotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesCountLbl: UILabel!
    private let searchController = UISearchController()
    
    var allNotes: [Note] = [] {
        didSet{
            notesCountLbl.text = "\(allNotes.count) \(allNotes.count == 1 ? "Note" : "Notes")"
            filteredNotes = allNotes
        }
    }
    
    var filteredNotes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    @IBAction func createNewNoteClicked(_ sender: UIButton) {
    }
    

   

}
