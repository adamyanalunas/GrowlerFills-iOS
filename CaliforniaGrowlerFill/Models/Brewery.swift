//
//  Brewery.swift
//  CaliforniaGrowlerFill
//
//  Created by Adam Yanalunas on 7/13/14.
//  Copyright (c) 2014 Subtracktion. All rights reserved.
//

import Foundation

let optionColors : [UIColor] = [
    UIColor(red: 227/255, green: 29/255,  blue: 18/255, alpha: 15/100),
    UIColor(red: 232/255, green: 152/255, blue: 60/255, alpha: 15/100),
    UIColor(red: 232/255, green: 212/255, blue: 60/255, alpha: 15/100),
    UIColor(red: 96/255,  green: 230/255, blue: 28/255, alpha: 15/100)
]

struct FillTypeOptions : RawOptionSetType, BooleanType {
    typealias RawValue = UInt
    private var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    init(rawValue value: UInt) { self.value = value }
    init(nilLiteral: ()) { self.value = 0 }
    static var allZeros: FillTypeOptions { return self(0) }
    
    // MARK: RawOptionSetType
    static func fromMask(raw: UInt) -> FillTypeOptions { return self(raw) }
    var rawValue: UInt { return self.value }
    
    // MARK: BooleanType
    var boolValue: Bool {
        return value != 0
    }
    
    static var None: FillTypeOptions { return self(0) }
    static var Blanks: FillTypeOptions   { return self(1 << 0) }
    static var OtherLabels: FillTypeOptions  { return self(1 << 1) }
    static var OneLiters: FillTypeOptions   { return self(1 << 2) }
}


class Brewery: NSObject {
    var name: String
    var fillOptions: FillTypeOptions
    var comments: String?
    var url: NSURL?
    var lastUpdated: NSDate?
    
    // MARK: LIfecycle
    init(name: String, fills: FillTypeOptions) {
        self.name = name
        self.fillOptions = fills
        self.comments = nil
        self.url = nil
        self.lastUpdated = nil
        super.init()
    }
    
    convenience override init() {
        self.init(name: "", fills: FillTypeOptions.None)
    }
    
    // MARK: Helpers
    func fillability() -> Int {
        var max : Int = 0
        
        if self.fillOptions & FillTypeOptions.Blanks {
            max++
        }
        
        if self.fillOptions & FillTypeOptions.OtherLabels {
            max++
        }
        
        if self.fillOptions & FillTypeOptions.OneLiters {
            max++
        }
        
        return max
    }
    
    class func fillOptionsToMask(options: NSDictionary) -> FillTypeOptions {
        var fills = FillTypeOptions.None
        
        if (options["blanks"] as String == "Y") {
            fills = (fills | FillTypeOptions.Blanks)
        }
        
        if (options["otherbreweries"] as String == "Y") {
            fills = (fills | FillTypeOptions.OtherLabels)
        }
        
        if (options["oneliters"] as String == "Y") {
            fills = (fills | FillTypeOptions.OneLiters)
        }
        
        return fills
    }
    
    func fillTypeColor() -> UIColor {
        return optionColors[self.fillability()]
    }
}