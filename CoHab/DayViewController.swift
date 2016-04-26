//
//  DayViewController.swift
//  CoHab
//
//  Created by Dominique Allen on 4/22/16.
//  Copyright © 2016 Christian . All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell

class DayViewController: UIViewController, /*UITableViewDataSource,*/ UITableViewDelegate {
    
    let ref = Firebase(url: "https://cohabapp.firebaseio.com/events")
    var items = [NSDictionary]()
    
    
}