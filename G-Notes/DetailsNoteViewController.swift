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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
        
        note.setValue(noteTextView.text, forKey: "note")
        note.setValue(titleTextField.text, forKey: "title")
        note.setValue(UUID(), forKey: "id")

        
        do {
            try context.save()
            print("saved")
        } catch {
            print("there is an error")
        }

    
        
        
        do {
            try context.save()
            print("Saved successfully")
        } catch let error as NSError {
            print("Error saving data: \(error.localizedDescription)")
        }

        

        
        NotificationCenter.default.post(name: Notification.Name("dataEntered"), object:nil)
        
        navigationController?.popViewController(animated: true)
//        saveden sonra tekrar note list ekranına dönsün
           
        

    }
}

