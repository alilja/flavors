//
//  ViewController.swift
//  Flavors
//
//  Created by Andrew on 4/18/15.
//  Copyright (c) 2015 Andrew Lilja. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var food_db = [String: FoodModel]()
    var menu = MenuModel(foods: [FoodModel]())
    
    @IBOutlet weak var mainTable: UITableView!
    
    // autocomplete stuff
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var autocompleteTableView: UITableView!
    var autocompleteText = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBox.delegate = self
        
        autocompleteTableView!.delegate = self
        autocompleteTableView!.dataSource = self
        autocompleteTableView!.scrollEnabled = true
        autocompleteTableView!.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == autocompleteTableView{
            return autocompleteText.count
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
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == autocompleteTableView{
            let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            searchBox.text = selectedCell.textLabel!.text
            autocompleteTableView.hidden = true
        }
    }
    
    // AUTOCOMPLETE //
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
        
        autocompleteTableView!.reloadData()
    }
}

