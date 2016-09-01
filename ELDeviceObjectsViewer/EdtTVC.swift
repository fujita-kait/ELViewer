//
//  EdtTVC.swift
//  ParseJSON_02
//
//  Created by Hiro Fujita on 2016/07/17.
//  Copyright © 2016年 SmartHouse. All rights reserved.
//

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
        if section == 0 {
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
                    label.text = "name"
                    detailLabel.text = epc.epcName
                case 1:
                    label.text = "size"
                    detailLabel.text = String(epc.epcSize)
                case 2:
                    label.text = "set"
                    detailLabel.text = epc.accessModeSet.rawValue
                case 3:
                    label.text = "get"
                    detailLabel.text = epc.accessModeGet.rawValue
                case 4:
                    label.text = "anno"
                    detailLabel.text = epc.accessModeAnno.rawValue
                case 5:
                    label.text = "remark"
                    let remark = epc.accessModeCondition ?? "nil"
                    detailLabel.text = remark
                default:
                    label.text = ""
                }
                
            } else {
                switch indexPath.row {
                case 0:
                    label.text = "name"
                    let name = epc.edt[indexPath.section - 1].elementName ?? "nil"
                    detailLabel.text = name
                case 1:
                    label.text = "size"
                    if epc.edt[indexPath.section - 1].elementSize == nil {
                        detailLabel.text = "nil"
                    } else {
                        detailLabel.text = String(epc.edt[indexPath.section - 1].elementSize!)
                    }
                case 2:
                    label.text = "repeat"
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
                                textForTitle.append("kvs")
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
    
    // header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return (epcCode + ": " + epcName)
        default:
            return ""
        }
    }

}