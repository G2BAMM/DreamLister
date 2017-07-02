//
//  ItemDetailVC.swift
//  DreamLister
//
//  Created by Brian McAulay on 30/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var txtTitle: CustomTextField!
    @IBOutlet weak var txtPrice: CustomTextField!
    @IBOutlet weak var txtDetails: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var btnImagePicker: UIButton!
    @IBOutlet weak var imgItemImage: UIImageView!
    
    @IBOutlet weak var btnAddEdit: UIButton!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storePicker.dataSource = self
        storePicker.delegate = self
        
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        /*
        let store = Store(context: context)
        store.name = "Amazon"
        let store2 = Store(context: context)
        store2.name = "eBay"
        let store3 = Store(context: context)
        store3.name = "Miller Homes"
        let store4 = Store(context: context)
        store4.name = "Arnold Clark"
        let store5 = Store(context: context)
        store5.name = "Apple"
        let store6 = Store(context: context)
        store6.name = "Konami"
        //Now save these
        ad.saveContext()
 */
        getStores()
        
        if itemToEdit != nil{
            loadItemData()
            btnAddEdit.setTitle("Update Item", for: .normal)
        } else {
            btnAddEdit.setTitle("Save Item", for: .normal)
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Fix this later
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            //Get our ordered list of stores
            let nameSort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSort]
            self.stores = try context.fetch(fetchRequest)
            //Now bind the stores to the picker
            self.storePicker.reloadAllComponents()
        } catch  {
            //Handle error
        }
    }
    
    
    @IBAction func btnSave_Click(_ sender: Any) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = imgItemImage.image
        
        if btnAddEdit.title(for: .normal) == "Save Item"{
            //This is a new item being added so context will be empty
            item = Item(context: context)
        }else{
            //Updating an existing item so we'll edit the pased item
            item = itemToEdit
        }
        
        if let title = txtTitle.text{
            item.title = title
        }
        
        if let price = txtPrice.text{
            item.price = (price as NSString).doubleValue
        }
        
        if let details = txtDetails.text{
            item.details = details
        }
        
        item.storeId = stores[storePicker.selectedRow(inComponent: 0)]
        item.imageId = picture
        
        //Now save our record to core data
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData(){
        if let item = itemToEdit{
            txtTitle.text = item.title
            txtPrice.text = "\(item.price)"
            txtDetails.text = item.details
            imgItemImage.image = item.imageId?.image as? UIImage
            if let store = item.storeId{
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                    
                } while index < stores.count
            }
        }
    }
    
    @IBAction func btnDelete_Clicked(_ sender: Any) {
        if itemToEdit != nil{
            context.delete(itemToEdit!)
            ad.saveContext()
            
        }
    _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func imageAdd(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgItemImage.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
