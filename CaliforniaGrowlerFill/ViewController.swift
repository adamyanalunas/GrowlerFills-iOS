//
//  ViewController.swift
//  CaliforniaGrowlerFill
//
//  Created by Adam Yanalunas on 7/13/14.
//  Copyright (c) 2014 Subtracktion. All rights reserved.
//

import UIKit

var breweries = [Brewery]()

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let brewery1 = Brewery(name: "Alpine")
        let brewery2 = Brewery(name: "Societe")
        let brewery3 = Brewery(name: "Modern Times")
        let brewery4 = Brewery(name: "Council")
        breweries = [brewery1, brewery2, brewery3, brewery4]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return breweries.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell: BreweryListingCell = collectionView.dequeueReusableCellWithReuseIdentifier("BreweryListingCell", forIndexPath: indexPath) as BreweryListingCell
        cell.backgroundColor = UIColor.grayColor()
        cell.breweryLabel.text = breweries[indexPath.item].name
        return cell
    }
}

