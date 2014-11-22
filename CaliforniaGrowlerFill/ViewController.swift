//
//  ViewController.swift
//  CaliforniaGrowlerFill
//
//  Created by Adam Yanalunas on 7/13/14.
//  Copyright (c) 2014 Subtracktion. All rights reserved.
//

import UIKit

var breweries = [Brewery]()

class ViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshList()
    }

    // MARK: UICollectionViewDataSource methods
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breweries.count
    }
    
    // MARK: UICollectionViewDelegate methods
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var breweryCell: BreweryListingCell = collectionView.dequeueReusableCellWithReuseIdentifier("BreweryListingCell", forIndexPath: indexPath) as BreweryListingCell
        let brewery: Brewery = breweries[indexPath.item]
        
        self.configureCellForBrewery(breweryCell, brewery: brewery)
        
        return breweryCell
    }
    
    // MARK: Configuration
    func configureCellForBrewery(cell: BreweryListingCell, brewery: Brewery) {
        cell.fillabilityView.backgroundColor = brewery.fillTypeColor()
        cell.breweryLabel.text = brewery.name
    }
    
    // MARK: Sorting
    func sortedByFillability(list: [Brewery]) -> [Brewery] {
//        func fillability(b1: Brewery, b2: Brewery) -> Bool {
//            return (b1.fillability() > b2.fillability())
//        }
//        
//        return sorted(list, fillability)
        var fillSortWithNames = {
            (b1: Brewery, b2: Brewery) -> Bool in
//            var result = false
            let fillability = b1.fillability() - b2.fillability()
            var result = fillability > 0
            
            if fillability != 0 {
                result = b1.name.compare(b2.name) == NSComparisonResult.OrderedAscending
            }
//            if b1.fillability() > b2.fillability() {
//                result = true
//            }
            
//            if result == false {
//                result = b1.name.compare(b2.name) == -1
//            }
            
            return result
        }
        
        var mutableList = list
        sort(&mutableList, fillSortWithNames)
        return mutableList
    }
    
    func sortedByName(list: [Brewery], ascending: Bool = false) -> [Brewery] {
        return sorted(list, { (b1: Brewery, b2: Brewery) -> Bool in
            return b1.name < b2.name
            });
    }
    
    // MARK: Network
    func refreshList() {
        self.getBreweries { (list : [Brewery]) -> Void in
//            breweries = self.sortedByFillability(list)
            breweries = self.sortedByName(list)
            self.collectionView.reloadData()
        }
    }
    
    func getBreweries(successClosure: ([Brewery]) -> Void) {
        var breweryList = [Brewery]()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let responseSerializer = AFJSONResponseSerializer()
        let requestSerializer = AFJSONRequestSerializer()
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = requestSerializer
        manager.responseSerializer = responseSerializer
        
        let requestSucess = {
            (operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let response:NSArray = responseObject as NSArray
            for breweryInfo: AnyObject in response {
                let name = breweryInfo["brewery"] as String
                let options = Brewery.fillOptionsToMask(breweryInfo as NSDictionary)
                let newBrewery = Brewery(name: name, fills: options)
                breweryList.append(newBrewery)
            }
            
            successClosure(breweryList)
        }
        
        manager.GET(
            "http://localhost:3000/api/breweries",
            parameters: nil,
            success: requestSucess,
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                println("Error: " + error.localizedDescription)
                let alert = UIAlertView.init(title: "Error", message: "Server not available", delegate: nil, cancelButtonTitle: "Okay")
                alert.show()
            })
    }
}

