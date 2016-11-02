//
//  TableViewDataSource.swift
//  swiftyTableView
//
//  Created by はるふ on 2016/11/02.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

struct SectionData<U> {
    var title = ""
    var items: [U]
}

class TableViewDataSource<T: UITableViewCell, U>: NSObject, UITableViewDataSource {
    
    private var cellIdentifierAtIndexPath: ((IndexPath) -> (String))?
    private var cellConstructor: ((T, U, IndexPath) -> ())?
    
    private var _sections = [SectionData<U>]([SectionData(title: "", items: [])]) {
        didSet {
            updateObserver?(oldValue, _sections)
        }
    }
    
    var updateObserver: (([SectionData<U>], [SectionData<U>]) -> ())?
    
    func setup(cellIdentifierAtIndexPath: @escaping ((IndexPath) -> (String)), cellConstructor: @escaping ((T, U, IndexPath) -> ())) {
        self.cellIdentifierAtIndexPath = cellIdentifierAtIndexPath
        self.cellConstructor = cellConstructor
    }
    
    func setup(cellIdentifier: String, cellConstructor: @escaping ((T, U, IndexPath) -> ())) {
        self.cellIdentifierAtIndexPath = { _ in cellIdentifier }
        self.cellConstructor = cellConstructor
    }
    
    // item1つ
    func append(_ item: U, section: Int = 0) {
        _sections[section].items.append(item)
    }
    func insert(_ item: U, row: Int, section: Int = 0) {
        _sections[section].items.insert(item, at: row)
    }
    func insert(_ item: U, indexPath: IndexPath) {
        _sections[indexPath.section].items.insert(item, at: indexPath.row)
    }
    
    // itemの配列
    func setItems(_ items: [U], section: Int = 0) {
        _sections[section].items = items
    }
    func setTitle(_ title: String, section: Int = 0) {
        _sections[section].title = title
    }
    
    // sectionまるごと
    func insert(_ sectionData: SectionData<U>, at section: Int) {
        _sections.insert(sectionData, at: section)
    }
    func append(_ sectionData: SectionData<U>) {
        _sections.append(sectionData)
    }
    
    func removeAll() {
        _sections = [SectionData<U>]([SectionData(title: "", items: [])])
    }
    
    // 以下、dataSource用
    func itemAtIndexPath(indexPath: IndexPath) -> U {
        return _sections[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return _sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = cellIdentifierAtIndexPath!(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! T
        let data = self.itemAtIndexPath(indexPath: indexPath)
        cellConstructor?(cell, data, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _sections[section].title
    }
}
