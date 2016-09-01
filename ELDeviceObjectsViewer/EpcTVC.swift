//  EpcTVC.swift
//  ParseJSON_02
//
//  Created by 藤田裕之 on 2016/07/15.
//  Copyright © 2016年 SmartHouse. All rights reserved.

import UIKit

class EpcTVC: UITableViewController {
    
    var epcs: [String:Epc]?
    let cellReuseIdentifier = "EpcCell"
    var epcCodes: [String]?
    var epc: Epc?
    var elObjCode = String()
    var elObjectName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "EPC"

        epcCodes = epcs!.keys.sort()

    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return (epcs!.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        
        if let label = cell.textLabel {
            label.text = epcCodes![indexPath.row]
        }
        
        if let detailLabel = cell.detailTextLabel {
            let epcCode = epcCodes![indexPath.row]
            detailLabel.text = epcs![epcCode]!.epcName
        }
        return cell
    }

    // Set Header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (elObjCode + ": " + elObjectName)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let edtTVC = segue.destinationViewController as? EdtTVC,
            cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell) {
            let epcCode = epcCodes![indexPath.row]
            epc = epcs![epcCode]!
            edtTVC.epc = epc
            edtTVC.epcCode = epcCode
            edtTVC.epcName = (epc?.epcName)!
        }
    }

}
