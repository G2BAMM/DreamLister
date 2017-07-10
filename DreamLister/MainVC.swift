//
//  ViewController.swift
//  DreamLister
//
//  Created by Brian McAulay on 28/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    var controller: NSFetchedResultsController<Item>!
    var stores = [Store]()
    var itemType = [ItemType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        checkCoreDataStorage()
        attemptFetch()
    }
    
    func checkCoreDataStorage(){
        let fetchStoreRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let fetchItemTypeRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        var noCoreData = false
        do {
            //Check our core data store
            self.stores = try context.fetch(fetchStoreRequest)
            self.itemType = try context.fetch(fetchItemTypeRequest)
            //Do we have any stores?
            if stores.count == 0{
                //No stores found so add some default values to the stores entity
                let store = Store(context: context)
                store.name = "Amazon"
                let store2 = Store(context: context)
                store2.name = "Top Man"
                let store3 = Store(context: context)
                store3.name = "ASDA"
                let store4 = Store(context: context)
                store4.name = "Tesco"
                let store5 = Store(context: context)
                store5.name = "Apple"
                let store6 = Store(context: context)
                store6.name = "PC World"
                noCoreData = true
            }
            
            //Do we have any item types
            if itemType.count == 0{
                //No item types were found so add some default values to the item type entity
                let itemType = ItemType(context: context)
                itemType.type = "Electronics"
                let itemType2 = ItemType(context: context)
                itemType2.type = "Holidays"
                let itemType3 = ItemType(context: context)
                itemType3.type = "Autos"
                let itemType4 = ItemType(context: context)
                itemType4.type = "Computers"
                let itemType5 = ItemType(context: context)
                itemType5.type = "Home"
                let itemType6 = ItemType(context: context)
                itemType6.type = "Clothes"
                noCoreData = true

            }
            
            if noCoreData{
                //Add a single item to the list so that we always have one item ready to show and edit when the app is first installed/used
                let item = Item(context: context)
                item.title = "Edit this title to set your own first item"
                item.price = 0.00
                item.details = "Edit this description to set your own first item"
                item.lastUpdated = getSummerTime(today: Date())
                
            }
            ad.saveContext()
            
        } catch  {
            //Handle error
            let error = error as NSError
            print("\(error)")
        }
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: DetailCell, indexPath: NSIndexPath){
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0{
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            if let destination = segue.destination as? ItemDetailVC{
                if let item = sender as? Item{
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let typeSort = NSSortDescriptor(key: "typeId.type", ascending: true)
        let storeSort = NSSortDescriptor(key: "storeId.name", ascending: true)
        switch segmentView.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
        case 2:
            fetchRequest.sortDescriptors = [titleSort]
        case 3:
            fetchRequest.sortDescriptors = [storeSort]
        default:
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do{
            try controller.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case.update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! DetailCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
        case.delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    
}

