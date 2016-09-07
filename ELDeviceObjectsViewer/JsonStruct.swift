//
//  JsonStruct.swift
//  ELDeviceObjectsViewer
//
//  Created by 藤田裕之 on 2016/09/07.

import Foundation
import Unbox

struct Appendix: Unboxable {
    let version: String
    let date: String
    let elObjects: [String:ElObject]
    
    init(unboxer: Unboxer) {
        self.version = unboxer.unbox("version")
        self.date = unboxer.unbox("date")
        self.elObjects = unboxer.unbox("elObjects")
    }
}

struct ElObject: Unboxable {
    let objectName: String
    let epcs: [String:Epc]
    
    init(unboxer: Unboxer) {
        self.objectName = unboxer.unbox("objectName")
        self.epcs = unboxer.unbox("epcs")
    }
}

struct Epc: Unboxable {
    let epcName: String        // EPC name
    let epcSize: Int           // Total data size
    let accessModeSet: AccessModeCode
    let accessModeGet: AccessModeCode
    let accessModeAnno: AccessModeCode
    let accessModeCondition: String?
    let edt: [Element]     // List of EDT Element

    init(unboxer: Unboxer) {
        self.epcName = unboxer.unbox("epcName")
        self.epcSize = unboxer.unbox("epcSize")
        self.accessModeSet = unboxer.unbox("accessModeSet")
        self.accessModeGet = unboxer.unbox("accessModeGet")
        self.accessModeAnno = unboxer.unbox("accessModeAnno")
        self.accessModeCondition = unboxer.unbox("accessModeCondition")       // default = nil
        self.edt = unboxer.unbox("edt")
    }
    enum AccessModeCode: String, UnboxableEnum {
        case required = "required"
        case optional = "optional"
        case notApplicable = "notApplicable"
        case ERROR = "ERROR"
        
        static func unboxFallbackValue() -> AccessModeCode {
            return .ERROR
        }
    }
}

struct Element: Unboxable {
    let elementName: String?
    let elementSize: Int?           // Size of Element
    let repeatCount: Int?        // Repeat Count of this Element. 0 means unfixed count
    let content: Content?  // Details of the Element

    init(unboxer: Unboxer) {
        self.elementName = unboxer.unbox("elementName")
        self.elementSize = unboxer.unbox("elementSize")
        self.repeatCount = unboxer.unbox("repeatCount")
        self.content = unboxer.unbox("content")
    }
}

struct Content: Unboxable {
    let keyValues: [String:String]?
    let numericValue: NumericValue?
    let bitmap: [BitMap]?     // bitmap data
    let level: Level?
    let rawData: String?
    let customType: String?
    let others: String?

    init(unboxer: Unboxer) {
        self.keyValues = unboxer.unbox("keyValues")
        self.numericValue = unboxer.unbox("numericValue")
        self.bitmap = unboxer.unbox("bitmap")
        self.level = unboxer.unbox("level")
        self.rawData = unboxer.unbox("rawData")
        self.customType = unboxer.unbox("customType")
        self.others = unboxer.unbox("others")
    }
}

struct NumericValue: Unboxable {
    let integerType: IntegerType    // Unsigned or Signed
    let magnification: Int?         // Power of 10, ex: x0.001 -> -3
    let unit: String?
    let min: Int
    let max: Int

    init(unboxer: Unboxer) {
        self.integerType = unboxer.unbox("integerType")
        self.magnification = (unboxer.unbox("magnification") ?? 0)    // default is x1
        self.unit = (unboxer.unbox("unit") ?? "N/A")
        self.min = unboxer.unbox("min")
        self.max = unboxer.unbox("max")
    }
    enum IntegerType: String, UnboxableEnum {
        case Unsigned = "Unsigned"   // Unsigned Int
        case Signed  = "Signed"    // Signed Int
        case ERROR = "ERROR" // ERROR
        
        static func unboxFallbackValue() -> IntegerType {
            return .ERROR
        }
    }
}

struct BitMap: Unboxable {
    let bitName: String
    let bitRange: [Int]
    let bitValues: [String:String]

    init(unboxer: Unboxer) {
        self.bitName = unboxer.unbox("bitName")
        self.bitRange = unboxer.unbox("bitRange")
        self.bitValues = unboxer.unbox("bitValues")
    }
}

struct Level: Unboxable {
    let min: Int
    let max: Int
    
    init(unboxer: Unboxer) {
        self.min = unboxer.unbox("min")
        self.max = unboxer.unbox("max")
    }
}
