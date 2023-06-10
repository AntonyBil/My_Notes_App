//
//  EditNoteViewController.swift
//  My_Notes
//
//  Created by apple on 08.06.2023.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    static let identifire = "EditNoteViewController"
    
    var note: Note!
    weak var delegate: ListNotesDelegate?
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = note?.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK: - methods to implement
    func updateNote() {
        //update the note in database
        print("Update Note")
        
        note.lastUpdated = Date()
        delegate?.refreshNoes()
    }
    
    func deleteNote() {
        //delete the note from database
        print("Delete note")
            delegate?.deleteNote(with: note.id)
    }
    
}

extension EditNoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note.text = textView.text
        if note.title.isEmpty {
            deleteNote()
        } else {
            updateNote()
        }
    }
}
