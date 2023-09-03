//
//  ViewController.swift
//  G-Notes
//
//  Created by Göknur Bulut on 3.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var notesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
//        add butonunun eklenmesi
        
        
    }

    @objc func addButtonClicked (){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)

        
        
    }

}

