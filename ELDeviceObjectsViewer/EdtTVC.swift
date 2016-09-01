//  EdtTVC.swift
//  ELDeviceObjectsViewer
//
//  Created by Hiro Fujita on 2016/09/01.
//  Copyright © 2016年 SmartHouse. All rights reserved.
//
//  STATUS: need to modify to implement level, rawData, customType and others

import UIKit

class EdtTVC: UITableViewController {
    
    var epc: Epc?
    let cellReuseIdentifier = "EdtCell"
    var textForTitle = [String]()
    var textForDetail = [String]()
    var epcCode = String()
    var epcName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "EDT"
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let countOfeElement = epc?.edt.count {
            return (countOfeElement + 1)
        }
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {   // 1st section consists of EPC name, size and access mode of set, get, anno and condition
            return 6
        } else {
            var numberOfRows = 3
//            print("section: \(section)")
            
            if let content = epc!.edt[section - 1].content {
                if let kvs = content.keyValues {
                    numberOfRows += kvs.count
                }
                if let bitmap = content.bitmap {
                    numberOfRows += bitmap.count
                }
                if content.numericValue != nil {
                    numberOfRows += 5
                }
            }
            return numberOfRows
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        
        if let label = cell.textLabel, detailLabel = cell.detailTextLabel, epc = epc {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    label.text = "Name"
                    detailLabel.text = epc.epcName
                case 1:
                    label.text = "Size"
                    detailLabel.text = String(epc.epcSize)
                case 2:
                    label.text = "Access mode Set"
                    detailLabel.text = epc.accessModeSet.rawValue
                case 3:
                    label.text = "Access mode Get"
                    detailLabel.text = epc.accessModeGet.rawValue
                case 4:
                    label.text = "Access mode Anno"
                    detailLabel.text = epc.accessModeAnno.rawValue
                case 5:
                    label.text = "Access mode Condition"
                    let remark = epc.accessModeCondition ?? ""
                    detailLabel.text = remark
                default:
                    label.text = ""
                }
                
            } else {        // Details of each Element
                switch indexPath.row {
                case 0:
                    label.text = "Element name"
                    let name = epc.edt[indexPath.section - 1].elementName ?? ""
                    detailLabel.text = name
                case 1:
                    label.text = "Element size"
                    if epc.edt[indexPath.section - 1].elementSize == nil {
                        detailLabel.text = "nil"
                    } else {
                        detailLabel.text = String(epc.edt[indexPath.section - 1].elementSize!)
                    }
                case 2:
                    label.text = "Repeat count"
                    if epc.edt[indexPath.section - 1].repeatCount == nil {
                        detailLabel.text = "nil"
                    } else {
                        detailLabel.text = String(epc.edt[indexPath.section - 1].repeatCount!)
                    }
                default:
                    var textForTitle = [String]()
                    var textForDetail = [String]()
                    if let content = epc.edt[indexPath.section - 1].content {
                        if let kvs = content.keyValues {
                            var tmp = [String]()
                            for (key, value) in kvs {
                                textForTitle.append("Key & Value")
                                tmp.append("\(key) : \(value)")
                            }
                            tmp.sortInPlace{$0 < $1}
                            textForDetail += tmp
                        }
                        if let bitmap = content.bitmap {
                            var bit = 0
                            for bm in bitmap {
                                textForTitle.append("bit\(bit)")
                                textForDetail.append("\(bm.name),0:\(bm.b0),1:\(bm.b1)")
                                bit += 1
                            }
                        }
                        if let value = content.numericValue {
                            textForTitle.append("value")
                            textForDetail.append("Type: \(value.integerType)")
                            textForTitle.append("value")
                            let mNum = pow(10.0, Double(value.magnification!))
                            textForDetail.append("Magnification: \(mNum)")
                            textForTitle.append("value")
                            let unit = value.unit!
                            textForDetail.append("unit: \(unit)")
                            textForTitle.append("value")
                            textForDetail.append("min: \(value.min)")
                            textForTitle.append("value")
                            textForDetail.append("max: \(value.max)")
                        }
                    }
                    label.text = textForTitle[indexPath.row - 3]
                    detailLabel.text = textForDetail[indexPath.row - 3]
                }
                
            }
        }
        return cell
    }
    
    // Set Header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return (epcCode + ": " + epcName)
        default:
            return ""
        }
    }

}