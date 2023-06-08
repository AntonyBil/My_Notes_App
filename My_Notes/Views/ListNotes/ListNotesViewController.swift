//
//  ListNotesViewController.swift
//  My_Notes
//
//  Created by apple on 07.06.2023.
//

import UIKit
protocol ListNotesDelegate: AnyObject {
    func refreshNoes()
    func deleteNote(with id: UUID)
}

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

        navigationController?.navigationBar.shadowImage = UIImage()
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        configureSearchBar()
       
    }
    
    func indexForNote(id: UUID, in list: [Note]) -> IndexPath {
        let row = Int(list.firstIndex(where: {$0.id == id}) ?? 0)
        return IndexPath(row: row, section: 0)
    }
    
    func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    func goToEditNote(_ note: Note) {
        let controller = storyboard?.instantiateViewController(withIdentifier: EditNoteViewController.identifire) as! EditNoteViewController
        controller.note = note
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func createNewNoteClicked(_ sender: UIButton) {
        goToEditNote(createNote())
    }
    
    func createNote() -> Note {
        let note = Note()
        
        //TODO Save note in database
        
        // Update table
        allNotes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    func featchNotesFromStorage() {
        //TODO Get all saved notes
        print("Featching all notes")
    }
    
    func deleteNoteFromStorege(_ note: Note) {
        //TODO Delete the note
        print("Deleting note")
        
        //Update the list
        deleteNote(with: note.id)
    }
    
    func searchNotesFromStorage(_ text: String) {
        //TODO get all notes that have this text
        print("Searching Notes")
    }

}

//MARK: - TableViewConfiguration
extension ListNotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListNoteTableViewCell.identifire) as! ListNoteTableViewCell
        cell.setUp(note: filteredNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToEditNote(filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNoteFromStorege(filteredNotes[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}


//MARK: - Search Controller Configuration
extension ListNotesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func search(_ query: String) {
        if query.count >= 1 {
            filteredNotes = allNotes.filter{ $0.text.lowercased().contains(query.lowercased())}
        } else {
            filteredNotes = allNotes
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchNotesFromStorage(query)
    }
}

//MARK: - ListNotesDelegate
extension ListNotesViewController: ListNotesDelegate {
    
    func refreshNoes() {
        allNotes = allNotes.sorted { $0.lastUpdated > $1.lastUpdated }
        tableView.reloadData()
    }
    
    func deleteNote(with id: UUID) {
        let indexPath = indexForNote(id: id, in: filteredNotes)
        filteredNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //just so thet it  doesen't come back when we search from the array
        allNotes.remove(at: indexForNote(id: id, in: allNotes).row)
    }
}
