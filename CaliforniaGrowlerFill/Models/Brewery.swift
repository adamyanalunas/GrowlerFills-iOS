//
//  Brewery.swift
//  CaliforniaGrowlerFill
//
//  Created by Adam Yanalunas on 7/13/14.
//  Copyright (c) 2014 Subtracktion. All rights reserved.
//

import Foundation

enum FillTypeOptions : UInt {
    case None        = 0
    case Blanks      = 1
    case OtherLabels = 2
    case OneLiters   = 4
}

class Brewery: NSObject {
    var name: String
    var fillOptions: FillTypeOptions
    var comments: String?
    var url: NSURL?
    var lastUpdated: NSDate?
    
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
}