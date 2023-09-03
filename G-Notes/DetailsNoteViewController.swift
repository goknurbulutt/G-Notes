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

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeTheKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
//        klavye dışında herhangi bir yere tıklandığında kapansın.
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveClicked))
//        save butonunun eklenmesi
    }
    
    
    @objc func closeTheKeyboard(){
        
        view.endEditing(true)
    }
    
    
    @objc func saveClicked(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
        
        note.setValue(noteTextView.text, forKey: "note")
        note.setValue(titleTextField.text, forKey: "title")
        note.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("kayıt edlildi")
        }catch{
            print("hata var")
        }
        
        
        
        
        
        
    }
    
    

    

}
