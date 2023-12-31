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
    
    var selectedName = ""
    var selectedUUID : UUID?
    
   
    
    
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
            if results.count > 0{
                
                for result in results as! [NSManagedObject]{
                    if let title = result.value(forKey: "title") as? String {
                        titleSeries.append(title)
                        
                    }
                    
                    
                    
                    
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        idSeries.append(id)
                    }
                    
                    notesTableView.reloadData()
                
            }
            
            
            }
        }catch{
            print("hata varr")
        }
    }
    

    @objc func addButtonClicked (){
        
        selectedName = ""
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsNoteViewController
            
            destinationVC.selectedNoteName = selectedName
            destinationVC.selectedNoteId = selectedUUID
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = titleSeries[indexPath.row]
        selectedUUID = idSeries[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            let uuidString = idSeries[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idSeries[indexPath.row] {
                                let alert = UIAlertController(title: "Note Deletion", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
                                
                                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                                    context.delete(result)
                                    self.titleSeries.remove(at: indexPath.row)
                                    self.idSeries.remove(at: indexPath.row)
                                    
                                    self.notesTableView.reloadData()
                                    
                                    do {
                                        try context.save()
                                    } catch {
                                        print("Not silinemedi")
                                    }
                                }
                                
                                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                                
                                alert.addAction(yesAction)
                                alert.addAction(noAction)
                                
                                present(alert, animated: true, completion: nil)
                                break
                            }
                        }
                    }
                }
            } catch {
                print("Veri çekilemedi")
            }
        }
    }

    
    
    
    




    
        
    }
