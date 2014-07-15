//
//  Brewery.swift
//  CaliforniaGrowlerFill
//
//  Created by Adam Yanalunas on 7/13/14.
//  Copyright (c) 2014 Subtracktion. All rights reserved.
//

import Foundation

struct FillTypeOptions : RawOptionSet {
    var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    func toRaw() -> UInt { return self.value }
    func getLogicValue() -> Bool { return self.value != 0 }
    static func fromRaw(raw: UInt) -> FillTypeOptions? { return self(raw) }
    static func fromMask(raw: UInt) -> FillTypeOptions { return self(raw) }
    static func convertFromNilLiteral() -> FillTypeOptions { return self(0) }
    
    static var None: FillTypeOptions          { return self(0) }
    static var Blanks: FillTypeOptions   { return self(1 << 0) }
    static var OtherLabels: FillTypeOptions  { return self(1 << 1) }
    static var OneLiters: FillTypeOptions   { return self(1 << 2) }
}
func == (lhs: FillTypeOptions, rhs: FillTypeOptions) -> Bool     { return lhs.value == rhs.value }


class Brewery: NSObject {
    var name: String
    var fillOptions: FillTypeOptions
    var comments: String?
    var url: NSURL?
    var lastUpdated: NSDate?
    
    // MARK: LIfecycle
    init(name: String, fills: FillTypeOptions) {
        self.name = name
        self.fillOptions = FillTypeOptions.None
        self.comments = nil
        self.url = nil
        self.lastUpdated = nil
        super.init()
    }
    
    convenience init() {
        self.init(name: "", fills: FillTypeOptions.None)
    }
    
    // MARK: Helpers
    class func fillOptionsToMask(options: NSDictionary) -> FillTypeOptions {
        var fills = FillTypeOptions.None
        
        if (options["blanks"]) {
            fills = (fills & FillTypeOptions.Blanks)
        }
        
        if (options["otherbreweries"]) {
            fills = (fills & FillTypeOptions.OtherLabels)
        }
        
        if (options["oneliters"]) {
            fills = (fills & FillTypeOptions.OneLiters)
        }
        
        return fills
    }
}