//
//  ViewController.swift
//  G-Notes
//
//  Created by Göknur Bulut on 3.09.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var notesTableView: UITableView!
    var titleSeries = [String]()
    var idSeries = [UUID]()
    
   
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
//        add butonunun eklenmesi
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        getData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name:NSNotification.Name(rawValue: "dataEntered") , object: nil)
    }
    
//    alınan verinin gözlemci fonk yardımıyla işlenmesi
    
    @objc func getData(){


        
        titleSeries.removeAll(keepingCapacity: false)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if let title = result.value(forKey: "title") as? String {
                    titleSeries.append(title)
                    
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    idSeries.append(id)
                }
                
                notesTableView.reloadData()
            }
        }catch{
            print("hata varr")
        }
    }
    

    @objc func addButtonClicked (){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)

        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleSeries[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return titleSeries.count

    }
    
    
    
}



