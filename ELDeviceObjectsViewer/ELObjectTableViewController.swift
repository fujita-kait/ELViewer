//  ELObjectTableViewController.swift
//  ELDeviceObjectsViewer
//
//  Created by 藤田裕之 on 2016/09/01.
//  Copyright © 2016年 SmartHouse. All rights reserved.
//
//  STATUS: Working

import UIKit
import Unbox

class ELObjectTableViewController: UITableViewController {
    
    let cellReuseIdentifier = "ELObjectCell"
    var appendix: Appendix?
    var elObjects: [String:ElObject]?
    var epcs: [String:Epc]?
    var deviceObjectCodes = [String]()
    var jsonFileName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "機器オブジェクト"    // Title
        print(jsonFileName)
        fetchDataAppendix()
    }
    
    // remove status bar
    override func prefersStatusBarHidden() -> Bool { return true }
    
    // read JSON file and Parse it with Unbox
    private func fetchDataAppendix() {
        let path = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: "json")
        let fileHandle = NSFileHandle(forReadingAtPath: path!)
        let data = fileHandle?.readDataToEndOfFile()
        
        do {
            let parsedData: Appendix = try Unbox(data!)
            appendix = parsedData
            elObjects = parsedData.elObjects
            deviceObjectCodes = (appendix?.elObjects.keys.sort())!
            print("deviceObjectCodes \(deviceObjectCodes)")
            
        } catch { print("ERROR Unbox") }
                
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return (appendix?.elObjects.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)

        if let label = cell.textLabel, deviceObjectCodes = appendix?.elObjects.keys.sort() {
            label.text = deviceObjectCodes[indexPath.row]
        }

        if let detailLabel = cell.detailTextLabel {
            let deviceObjectCode = deviceObjectCodes[indexPath.row]
            
            detailLabel.text = appendix?.elObjects[deviceObjectCode]!.objectName
        }
        return cell
    }
    
    // Set Header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let release = appendix?.version, date = appendix?.date {
            return "Release \(release):\t\t\t\t\(date)"
        }
        return ""
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let epcTVC = segue.destinationViewController as? EpcTVC,
            cell = sender as? UITableViewCell,
            indexPath = self.tableView.indexPathForCell(cell) {
            let deviceObjectCode = deviceObjectCodes[indexPath.row]
            epcs = elObjects![deviceObjectCode]!.epcs
            epcTVC.epcs = epcs
            epcTVC.elObjCode = deviceObjectCode
            epcTVC.elObjectName = elObjects![deviceObjectCode]!.objectName
        }
    }

}
