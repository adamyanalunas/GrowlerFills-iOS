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
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return breweries.count
    }
    
    // MARK: UICollectionViewDelegate methods
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var breweryCell: BreweryListingCell = collectionView.dequeueReusableCellWithReuseIdentifier("BreweryListingCell", forIndexPath: indexPath) as BreweryListingCell
        let brewery: Brewery = breweries[indexPath.item]
        
        self.configureCellForBrewery(breweryCell, brewery: brewery)
        
        return breweryCell
    }
    
    // MARK: Configuration
    func configureCellForBrewery(cell: BreweryListingCell, brewery: Brewery) {
        cell.fillabilityView.backgroundColor = Brewery.fillTypeColor(brewery.fillOptions)
        cell.breweryLabel.text = brewery.name
    }
    
    // MARK: Sorting
    func sortedByFillability(list: [Brewery]) -> [Brewery] {
        func fillability(b1: Brewery, b2: Brewery) -> Bool {
            return (b1.fillability() > b2.fillability())
        }
        
        return sorted(list, fillability)
    }
    
    // MARK: Network
    func refreshList() {
        self.getBreweries { (list : [Brewery]) -> Void in
            breweries = self.sortedByFillability(list)
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
                breweryList += newBrewery
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
            })
    }
}

