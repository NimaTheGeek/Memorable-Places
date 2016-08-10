//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Nima Farahani on 8/9/16.
//  Copyright © 2016 Nima Farahani. All rights reserved.
//

import UIKit

// creating arrays or dictionaries
var places = [Dictionary <String, String>()]
// check if user clicked on a saved place
var activePlaces = -1

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if places.count == 1 {
            
            places.removeAtIndex(0)
            places.append(["name":"Greenwich", "lat":"51.4826" , "lon":"0.0077"])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = places[indexPath.row]["name"]

        return cell
    }
    
    //to check what which item user clicked on
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        activePlaces = indexPath.row
        return indexPath
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlace"{
            activePlaces = -1
        }
    }
    
    //to update the table after selecting a location
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

}
