//
//  MainViewController.swift
//  Flavors
//
//  Created by Andrew on 4/18/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var food_db = [String: FoodModel]()
    var menu = MenuModel(foods: [FoodModel]())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBox.delegate = self
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        
        mainTable.registerNib(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "Food")
        mainTable.registerNib(UINib(nibName: "FlavorCell", bundle: nil), forCellReuseIdentifier: "Flavors")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: All TableViews
    
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
            let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
            var cell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier) as? UITableViewCell
            
            if let tempo1 = cell{
                let index = indexPath.row as Int
                cell!.textLabel!.text = autocompleteText[index]
            } else {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: autoCompleteRowIdentifier)
            }
            return cell!
        }
        
        if tableView == mainTable {
            if indexPath.section == 0 {
                let cell:FoodCell = tableView.dequeueReusableCellWithIdentifier("Food") as! FoodCell
                cell.foodLabel?.text = menu.foods[indexPath.row].name
                cell.fitLabel?.text = String(format: "%.0f", menu.foods[indexPath.row].getFit() * 100)
                return cell
            } else {
                let cell:FlavorCell = tableView.dequeueReusableCellWithIdentifier("Flavors") as! FlavorCell
                cell.sizeToFit()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == mainTable{
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == mainTable && indexPath.section == 1 {
            return 320
        }
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == autocompleteTableView{
            if indexPath.section == 0 {
                let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
                searchBox.text = selectedCell.textLabel!.text
                autocompleteTableView.hidden = true
                addItemToMenu()
            }
        }
    }
    
    // MARK: Autocomplete List
    // add in-line completion; probably will need a second layer

    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var autocompleteTableView: UITableView!
    var autocompleteText = [String]()
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        autocompleteTableView!.hidden = false
        var substring = (self.searchBox.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        return true
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
        if frame.size.height + frame.origin.y > screenSize.height {
            frame.size.height = screenSize.height - frame.origin.y
        }
        autocompleteTableView.frame = frame
    }
    
    func addItemToMenu(){
        if searchBox.text != "" && contains(food_db.keys.array, searchBox.text){
            let foodToAdd:FoodModel = food_db[searchBox.text]!
            if !contains(menu.foods, foodToAdd){
                menu.add(foodToAdd)
                searchBox.text = ""
                mainTable.reloadData()
            }
        }
    }
    
    @IBAction func addFood(sender: AnyObject) {
        addItemToMenu()
    }
    
}

