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
    
    let dataManager = TableViewDataManager<SampleTableViewCell, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = self.view.frame
        self.view.addSubview(tableView)
        
        tableView.register(SampleTableViewCell.self, forCellReuseIdentifier: "SampleTableViewCell")
        
        dataManager.setup(cellIdentifier: "SampleTableViewCell") { cell, data, indexPath in
            cell.textLabel?.text = data
        }.bindTo(tableView)
        dataManager.setItems(["い", "ろ", "は", "に", "ほ", "へ", "と"])
    }
    
    // 以下はサンプル用
    private var sampleTimers = [Timer]()
    private func setSampleTimers() {
        sampleTimers = [
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[weak self] _ in
                self?.dataManager.append("に")
                self?.dataManager.insert("は", row: 2)
            },
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) {[weak self] _ in
                self?.dataManager.delete(row: 0)
            },
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {[weak self] _ in
                self?.dataManager.append(SectionData(title: "動物", items: ["ねこ", "いぬ", "くじら"]))
            },
            Timer.scheduledTimer(withTimeInterval: 7, repeats: true) {[weak self] _ in
                self?.dataManager.delete(section: 0)
            },
            Timer.scheduledTimer(withTimeInterval: 1.7, repeats: true) {[weak self] _ in
                self?.dataManager.insertAnimation = .middle
                self?.dataManager.deleteAnimation = .middle
            }
        ]
    }
    private func removeSampleTimers() {
        sampleTimers.forEach {
            $0.invalidate()
        }
        sampleTimers.removeAll()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSampleTimers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSampleTimers()
    }
}

