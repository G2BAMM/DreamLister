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
    @IBOutlet weak var itemTypePicker: UIPickerView!
    @IBOutlet weak var btnAddEdit: UIButton!
    @IBOutlet weak var btnSelectType: UIButton!
    @IBOutlet weak var btnSelectStore: UIButton!
    @IBOutlet weak var vwDoneAndCancel: UIView!
    @IBOutlet weak var vwStoresAndTypes: UIView!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add our delegates and datasources to the conroller
        storePicker.dataSource = self
        storePicker.delegate = self
        itemTypePicker.dataSource = self
        itemTypePicker.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //Set our top navigation bar back button
        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        //Check if we have stores and item types already set up
        getStoresAndTypes()
        
        //Are we updating or creating an item
        if itemToEdit != nil{
            //We have an item entity so load the item and update the UI
            loadItemData()
            //We are updating so change the title of the button to  'Update Item'
            btnAddEdit.setTitle("Update Item", for: .normal)
        } else {
            //No current entity so display a blank form and set the button title to be 'Add New Item'
            btnAddEdit.setTitle("Add New Item", for: .normal)
            
            //Hide the button until everything has been properly populated
            btnAddEdit.isHidden = true
        }
        
        //Hide the pickers until they are required
        storePicker.isHidden = true
        itemTypePicker.isHidden = true
        
        //Hide the picker tool bar
        vwDoneAndCancel.isHidden = true
        
        //Check whether we can show the update or save button for this item
        checkSaveButton()
    }
    
    
    @IBAction func btnPickStore_Clicked(_ sender: Any) {
        //Set the input screen up ready to pick a store
        vwStoresAndTypes.isHidden = true
        vwDoneAndCancel.isHidden = false
        storePicker.isHidden = false
        btnAddEdit.isHidden = true
    }
    
    
    @IBAction func btnItemType_Clicked(_ sender: Any) {
        //Set the input screen up ready to pick an item type
        vwStoresAndTypes.isHidden = true
        vwDoneAndCancel.isHidden = false
        itemTypePicker.isHidden = false
        btnAddEdit.isHidden = true
    }
    
    
    @IBAction func btnDone_Clicked(_ sender: Any) {
        //Update the UI after selecting an item from either picker
        if storePicker.isHidden == false{
            //We just clicked on the store picker so check if we should set a store for the first time
            if btnSelectStore.title(for: .normal) == "Select Store"{
                btnSelectStore.setTitle(stores[storePicker.selectedRow(inComponent: 0)].name, for: .normal)
            }
        }else{
            //We just clicked on the item type picker so check if we should set a type for the first time
            if btnSelectType.title(for: .normal) == "Select Type"{
                btnSelectType.setTitle(itemTypes[itemTypePicker.selectedRow(inComponent: 0)].type, for: .normal)
            }
        }
        
        //Hide both pickers now
        storePicker.isHidden = true
        itemTypePicker.isHidden = true
        
        //Now we can set our UI back to the normal form view
        vwStoresAndTypes.isHidden = false
        vwDoneAndCancel.isHidden = true
        
        //Now test to see if we can save or update
        checkSaveButton()
    }
    
    @IBAction func btnCancel_Clicked(_ sender: Any) {
        //Return to previous view discarding any changes when either picker is cancelled
        vwStoresAndTypes.isHidden = false
        vwDoneAndCancel.isHidden = true
        storePicker.isHidden = true
        itemTypePicker.isHidden = true
        //Now test to see if we can save or update
        checkSaveButton()
    }
    
    func checkSaveButton(){
        //Check to make sure we have completed every item
        if txtDetails.text == ""
        || txtPrice.text == ""
        || txtTitle.text == ""
        || btnSelectStore.title(for: .normal) == "Select Store"
        || btnSelectType.title(for: .normal) == "Select Type"{
            //Some items were not completed so prevent updates and saves
            btnAddEdit.isHidden = true
        }else{
            //All items are completed so allow updates and saves
            btnAddEdit.isHidden = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //Which picker are we working with
        if pickerView == storePicker{
            //Picker being built is the storePicker so bind to the stores array
            return stores.count
        }else{
            //Picker being built is itemTypePicker so bind to the itemsType array
            return itemTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Which picker are we working with
        if pickerView == storePicker{
            //Picker being built is the storePicker so bind the text to the store name for this row
                let store = stores[row]
                return store.name
           }else{
            //Picker being built is the itemTypesPicker so bind the text to the item type for this row
                let itemType = itemTypes[row]
                return itemType.type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == storePicker{
            btnSelectStore.setTitle(stores[storePicker.selectedRow(inComponent: 0)].name, for: .normal)
        }else{
            btnSelectType.setTitle(itemTypes[itemTypePicker.selectedRow(inComponent: 0)].type, for: .normal)
        }
    }
    
    func getStoresAndTypes(){
        let fetchStoreRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let fetchItemTypeRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            //Get our ordered list of stores and item types
            var nameSort = NSSortDescriptor(key: "name", ascending: true)
            fetchStoreRequest.sortDescriptors = [nameSort]
            self.stores = try context.fetch(fetchStoreRequest)
            nameSort = NSSortDescriptor(key: "type", ascending: true)
            fetchItemTypeRequest.sortDescriptors = [nameSort]
            self.itemTypes = try context.fetch(fetchItemTypeRequest)
            //Now bind the stores and item types to the pickers
            self.storePicker.reloadAllComponents()
            self.itemTypePicker.reloadAllComponents()
            }
        catch  {
                let error = error as NSError
                print("\(error)")
        }
    }
    
    
    @IBAction func btnSave_Click(_ sender: Any) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = imgItemImage.image
        
        if btnAddEdit.title(for: .normal) == "Add New Item"{
            //This is a new item being added so context will be empty
            item = Item(context: context)
        }else{
            //Updating an existing item so we'll edit the passed item
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
        item.typeId = itemTypes[itemTypePicker.selectedRow(inComponent: 0)]
        item.imageId = picture
        item.lastUpdated = getSummerTime(today: Date())
        
        //Now save our record to core data
        ad.saveContext()
        
        //Gracefully return to the table view
        navigationController?.popViewController(animated: true)
    }
    
    func loadItemData(){
        if let item = itemToEdit{
            txtTitle.text = item.title
            txtPrice.text = "\(item.price)"
            txtDetails.text = item.details
            imgItemImage.image = item.imageId?.image as? UIImage
            if imgItemImage.image == nil{
                //Always make sure we have a thumbnail even if there is no image stored for this item
                imgItemImage.image = UIImage(named: "imagePick")
            }
            //Pre select our current saved store in the picker list
            if let store = item.storeId{
                var index = 0
                repeat{
                    let s = stores[index]
                    if s.name == store.name{
                        //Found our store so set the picker to this item
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        //Set the button text to match the store already saved for this item
                        btnSelectStore.setTitle(s.name, for: .normal)
                        break
                    }
                    index += 1
                    
                } while index < stores.count
            }
            //Pre select the correct item in the itemType picker list
            if let itemType = item.typeId{
                var index = 0
                repeat{
                    let i = itemTypes[index]
                    if i.type == itemType.type{
                        //Found our item type so set the picker to this item
                        itemTypePicker.selectRow(index, inComponent: 0, animated: false)
                        //Set the button text to match the item type already stored for this item
                        btnSelectType.setTitle(i.type, for: .normal)
                        break
                    }
                    index += 1
                    
                } while index < itemTypes.count
            }
         }
    }
    
    @IBAction func btnDelete_Clicked(_ sender: Any) {
        //Check to make sure we have an item to delete
        if itemToEdit != nil{
            //Set the context to ready to delete
            context.delete(itemToEdit!)
            //Update core data to remove this item
            ad.saveContext()
        }
    //Gracefully return to the table view after removing this item
    navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func imageAdd(_ sender: Any) {
        //User clicked the image on the edit form so we need to present the image picker to them
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Chcek to see if the user picked an image or not
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //Set the image on the form to be the one chosen
            imgItemImage.image = img
        }
        //Always dismiss the image picker after picking an item
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
