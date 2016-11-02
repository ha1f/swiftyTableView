//
//  ViewController.swift
//  swiftyTableView
//
//  Created by はるふ on 2016/11/02.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView = UITableView()
    
    let dataSource = TableViewDataSource<SampleTableViewCell, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = self.view.frame
        self.view.addSubview(tableView)
        
        tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: "cell")
        
        dataSource.setup(cellIdentifier: "cell") { cell, data, indexPath in
            cell.textLabel?.text = data
        }
        tableView.dataSource = dataSource
        dataSource.updateObserver = {[weak self] oldValue, newValue in
            self?.tableView.reloadData()
        }
        dataSource.setItems(["い", "ろ"])
        dataSource.append("に")
        dataSource.insert("は", row: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

