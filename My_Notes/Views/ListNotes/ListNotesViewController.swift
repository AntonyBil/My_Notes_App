//
//  ListNotesViewController.swift
//  My_Notes
//
//  Created by apple on 07.06.2023.
//

import UIKit
import CoreData


class ListNotesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesCountLbl: UILabel!
    
    private let searchController = UISearchController()
    
    var fetchedResultsController: NSFetchedResultsController<Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.shadowImage = UIImage()
        tableView.contentInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        configureSearchBar()
        setupFetchResultsController()
        refreshCountLbl()
       
    }
    
    func refreshCountLbl() {
        let count = fetchedResultsController.sections![0].numberOfObjects
        notesCountLbl.text = "\(count) \(count == 1 ? "Note" : "Notes")"
    }
    
    func setupFetchResultsController(filter: String? = nil) {
        fetchedResultsController = CoreDataManager.shered.createNotesFetchResultsController(filter: filter)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        refreshCountLbl()
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
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func createNewNoteClicked(_ sender: UIButton) {
        goToEditNote(createNote())
    }
    
    func createNote() -> Note {
        let note = CoreDataManager.shered.createNote()
        return note
    }
    
    func deleteNoteFromStorege(_ note: Note) {
        CoreDataManager.shered.deleteNote(note)
    }

}

//MARK: - TableViewConfiguration
extension ListNotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let notes = fetchedResultsController.sections![section]
        return notes.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListNoteTableViewCell.identifire) as! ListNoteTableViewCell
        let note = fetchedResultsController.object(at: indexPath)
        cell.setUp(note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        goToEditNote(note)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = fetchedResultsController.object(at: indexPath)
            deleteNoteFromStorege(note)
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
            setupFetchResultsController(filter: query)
        } else {
            setupFetchResultsController()
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
        search(searchBar.text ?? "")
    }
}


//MARK: - NSFetchedResultsController Delegates
extension ListNotesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default: tableView.reloadData()
        }
        refreshCountLbl()
    }
}
