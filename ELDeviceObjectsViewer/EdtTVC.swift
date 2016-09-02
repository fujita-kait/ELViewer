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
                if let bitmaps = content.bitmap {
                    for bitmap in bitmaps {
                        numberOfRows += 2   //  name and range
                        numberOfRows += bitmap.bitValues.count
                    }
                }
                if content.numericValue != nil {
                    numberOfRows += 5
                }
                if content.level != nil {
                    numberOfRows += 2
                }
                if content.rawData != nil {
                    numberOfRows += 1
                }
                if content.customType != nil {
                    numberOfRows += 1
                }
                if content.others != nil {
                    numberOfRows += 1
                }
            }
            return numberOfRows
        }
    }
    
    func convertAccsessModeText(text:String) -> String {
        var returnValue = text
        switch text {
        case "required":
            returnValue = "Required"
        case "requiredWithCondition":
            returnValue = "Required with condition"
        case "optional":
            returnValue = "Optional"
        case "notApplicable":
            returnValue = "Not applicable"
        default:
            break
        }
        return returnValue
    }

    func convertOthersText(text:String) -> String {
        var returnValue = text
        switch text {
        case "referSpec":
            returnValue = "Refer Appendix"
        case "reserved":
            returnValue = "Reserved"
        default:
            break
        }
        return returnValue
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        
        if let label = cell.textLabel, detailLabel = cell.detailTextLabel, epc = epc {
            // section 0, common data
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
                    detailLabel.text = convertAccsessModeText(epc.accessModeSet.rawValue)
                case 3:
                    label.text = "Access mode Get"
                    detailLabel.text = convertAccsessModeText(epc.accessModeGet.rawValue)
                case 4:
                    label.text = "Access mode Anno"
                    detailLabel.text = convertAccsessModeText(epc.accessModeAnno.rawValue)
                case 5:
                    label.text = "Access mode Condition"
                    let remark = epc.accessModeCondition ?? ""
                    detailLabel.text = remark
                default:
                    label.text = ""
                }
            } else {        // Details of each Element
                // common items for each element
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
                // content specific data
                // TODO: need to modify to implement level, rawData, customType and others
                default:
                    var textForTitle = [String]()
                    var textForDetail = [String]()
                    if let content = epc.edt[indexPath.section - 1].content {
                        // Key & Value
                        if let kvs = content.keyValues {
                            var tmp = [String]()
                            for (key, value) in kvs {
                                textForTitle.append("Key & Value")
                                tmp.append("\(key) : \(value)")
                            }
                            tmp.sortInPlace{$0 < $1}
                            textForDetail += tmp
                        }
                        // Numeric Value
                        if let value = content.numericValue {
                            textForTitle.append("Numeric Value")
                            textForDetail.append("Type: \(value.integerType)")
                            textForTitle.append("Numeric Value")
                            let mNum = pow(10.0, Double(value.magnification!))
                            textForDetail.append("Magnification: \(mNum)")
                            textForTitle.append("Numeric Value")
                            let unit = value.unit!
                            textForDetail.append("Unit: \(unit)")
                            textForTitle.append("Numeric Value")
                            textForDetail.append("Min: \(value.min)")
                            textForTitle.append("Numeric Value")
                            
                            // add "," to every 3 digit
                            let formatter = NSNumberFormatter()
                            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                            formatter.groupingSeparator = ","
                            formatter.groupingSize = 3
                            if let result = formatter.stringFromNumber(NSNumber(integer: value.max)) {
                                textForDetail.append("Max: \(result)")
                            }
                        }
                        // Bitmap
                        if let bitmaps = content.bitmap {
                            for bitmap in bitmaps {
                                textForTitle.append("Bitmap: Name")
                                textForDetail.append("\(bitmap.bitName)")
                                textForTitle.append("Bitmap: Range")
                                textForDetail.append("\(bitmap.bitRange)")
                                var tmp = [String]()
                                for (key, value) in bitmap.bitValues {
                                    textForTitle.append("Bitmap: Value")
                                    tmp.append("\(key) : \(value)")
                                }
                                tmp.sortInPlace{$0 < $1}
                                textForDetail += tmp
                            }
                        }
                        
                        // Level
                        if let level = content.level {
                            textForTitle.append("Level: MIN")
                            textForDetail.append("\(level.min)")
                            textForTitle.append("Level: MAX")
                            textForDetail.append("\(level.max)")
                        }
                        // rawData
                        if let rawData = content.rawData {
                            textForTitle.append("Raw Data")
                            textForDetail.append(rawData)
                        }
                        // customType
                        if let customType = content.customType {
                            textForTitle.append("Custom Type")
                            textForDetail.append(customType)
                        }
                        // others
                        if let others = content.others {
                            textForTitle.append("Others")
                            textForDetail.append(convertOthersText(others))
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
            return ("Element \(section)")
        }
    }

}