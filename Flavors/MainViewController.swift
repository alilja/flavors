//
//  MainViewController.swift
//  Flavors
//
//  Created by Andrew on 4/18/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//




// BUILD-A-MEAL
// BUILD-A-MEAL
// BUILD-A-MEAL
// BUILD-A-MEAL
// BUILD-A-MEAL
// BUILD-A-MEAL
// BUILD-A-MEAL
// BUILD-A-MEAL



import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var food_db = [String: FoodModel]()
    var menu = MenuModel(foods: [FoodModel]())
    var fits = [FoodModel: Float]()
    var sharedFlavors = [String: Int]()
    
    var collectionView: UICollectionView!
    var sizingCell: LabelCell!
    var collectionSize: CGFloat!
    
    var keyboardSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBox.delegate = self
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        
        mainTable.registerNib(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "Food")
        mainTable.registerClass(FlavorCell.self, forCellReuseIdentifier: "Flavors")
        
        mainTable.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        // Get a LabelCell that we can use as a size prototype
        let cellNib = UINib(nibName: "LabelCell", bundle: nil)
        self.sizingCell = (cellNib.instantiateWithOwner(nil, options: nil) as Array)[0] as! LabelCell
        
        self.collectionSize = 0
        
        // For adjusting autocomplete list size
        self.keyboardSize = CGSize(width: 0, height: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillAppear:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
        
        self.mainTable.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("hideKeyboard")))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func menuChanged(){
        let rawFits = menu.getFits()
        if rawFits.values.array.count > 0{
            let maxFit = maxElement(rawFits.values.array)
            for (food, raw) in rawFits{
                self.fits[food] = raw / maxFit
            }
        }
        self.sharedFlavors = menu.getSharedFlavors(2)
        let collection = (mainTable.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! FlavorCell).collectionView
        collection.reloadData()
        //collection.collectionViewLayout.prepareLayout()
        self.collectionSize = collection.collectionViewLayout.collectionViewContentSize().height
        mainTable.reloadData()
    }
    
    // MARK: TableViews
    
    @IBOutlet weak var mainTable: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == autocompleteTableView{
            return autocompleteText.count
        }
        if tableView == mainTable{
            if section == 0 {
                return menu.foods.count
            } else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView == autocompleteTableView{
            let cell = tableView.dequeueReusableCellWithIdentifier("AutocompleteItem") as! UITableViewCell
            cell.textLabel!.text = autocompleteText[indexPath.row]
            return cell
        }
        
        if tableView == mainTable {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("Food") as! FoodCell
                let food = menu.foods[indexPath.row]
                cell.foodLabel!.text = food.name
                cell.updateFit(self.fits[food]!)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("Flavors", forIndexPath: indexPath) as! FlavorCell
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = indexPath.row
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0{
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete{
            self.menu.foods.removeAtIndex(indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            self.menuChanged()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == mainTable{
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == mainTable && indexPath.section == 1 {
            if self.collectionSize > 0{
                return self.collectionSize + 10
            }
            return 0            
        }
        return 44
    }
    
    // MARK: Autocomplete List
    // add in-line completion; probably will need a second layer
    
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var autocompleteTableView: UITableView!
    var autocompleteText = [String]()
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        if tableView == autocompleteTableView{
            if indexPath.section == 0 {
                let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
                searchBox.text = selectedCell.textLabel!.text
                updateAutocomplete()
            }
        }
        /*if tableView == mainTable{
            if indexPath.section == 0{
                self.navigationController?.pushViewController(D, animated: <#Bool#>)
            }
        }*/
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String){
        autocompleteText.removeAll(keepCapacity: false)
        
        for curString in food_db.keys.array{
            var myString: NSString! = curString as NSString
            var substringRange: NSRange! = myString.rangeOfString(substring)
            if substringRange.location == 0 {
                autocompleteText.append(curString)
            }
        }
        // have to reload the data first so the size is correct
        autocompleteTableView.reloadData()
        
        var frame = autocompleteTableView.frame
        frame.size.height = autocompleteTableView.contentSize.height
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if frame.size.height + frame.origin.y > screenSize.height - self.keyboardSize.height {
            frame.size.height = screenSize.height - frame.origin.y - self.keyboardSize.height
        }
        autocompleteTableView.frame = frame
    }
    
    func updateAutocomplete(){
        autocompleteTableView.hidden = true
        if searchBox.text != "" && contains(food_db.keys.array, searchBox.text){
            let foodToAdd:FoodModel = food_db[searchBox.text]!
            if !contains(menu.foods, foodToAdd){
                menu.add(foodToAdd)
                self.menuChanged()
            }
            searchBox.text = ""
        }
    }
    
    @IBAction func addFood(sender: AnyObject) {
        updateAutocomplete()
    }
    
    
    // MARK: Text Field
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.searchBox {
            autocompleteTableView.hidden = false
            var substring = (self.searchBox.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            self.searchAutocompleteEntriesWithSubstring(substring)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool{
        if textField == self.searchBox{
            self.updateAutocomplete()
        }
        return true
    }
    
    func hideKeyboard(){
        self.searchBox.resignFirstResponder()
        self.updateAutocomplete()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.hideKeyboard()
        super.touchesBegan(touches, withEvent: event)
    }
    
    // MARK: Keyboard Stuff
    
    func keyboardWillAppear(notification: NSNotification) {
        if let size = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.keyboardSize = CGSize(width: size.width, height: size.height)
        }
    }
    
    func keyboardWillHide() {
        self.keyboardSize = CGSize(width: 0, height: 0)
    }
    
}


