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
        self.getBreweries()
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
        cell.backgroundColor = Brewery.fillTypeColor(brewery.fillOptions)
        cell.breweryLabel.text = brewery.name
    }
    
    // MARK: Network
    func getBreweries() {
        let responseSerializer = AFJSONResponseSerializer()
        let requestSerializer = AFJSONRequestSerializer()
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = requestSerializer
        manager.responseSerializer = responseSerializer
        
        let requestSucess = {
            (operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
            let response:NSArray = responseObject as NSArray
            for breweryInfo: AnyObject in response {
                let name = breweryInfo["brewery"] as String
                let options = Brewery.fillOptionsToMask(breweryInfo as NSDictionary)
                let newBrewery = Brewery(name: name, fills: options)
                breweries += newBrewery
            }
            self.collectionView.reloadData()
        }
        
        manager.GET(
            "http://localhost:3000/api/breweries",
            parameters: nil,
            success: requestSucess,
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
            })
    }
}

