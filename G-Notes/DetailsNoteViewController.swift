//
//  DetailsNoteViewController.swift
//  G-Notes
//
//  Created by Göknur Bulut on 3.09.2023.
//

import UIKit
import CoreData

class DetailsNoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    
    var selectedNoteName = ""
    var selectedNoteId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if selectedNoteName != ""{
            if let uuidString = selectedNoteId?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                
                do{
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0{
                        
                        for result in results as! [NSManagedObject]{
                            
                            
                            if let title = result.value(forKey: "title") as? String {
                                titleTextField.text = title
                                
                            }
                            
                            if let note = result.value(forKey: "note") as? String {
                                noteTextView.text = note
                            }
                            
                    }
                    
                    
                    }
                }catch{
                    print("hata varr")
                }
             
            }
            
        }else {
            titleTextField.text = ""
            noteTextView.text = ""
        }
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveClicked))
        navigationItem.rightBarButtonItem = saveButton
//
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeTheKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func closeTheKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let uuidString = selectedNoteId?.uuidString {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    if let noteToUpdate = results.first as? NSManagedObject {
                        noteToUpdate.setValue(titleTextField.text, forKey: "title")
                        noteToUpdate.setValue(noteTextView.text, forKey: "note")
                        
                        do {
                            try context.save()
                            print("Note updated successfully")
                        } catch let error as NSError {
                            print("Error updating note: \(error.localizedDescription)")
                        }
                    }
                }
            } catch {
                print("Error fetching note: \(error.localizedDescription)")
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name("dataEntered"), object: nil)
        
        navigationController?.popViewController(animated: true)
    }

}

