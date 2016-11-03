//
//  TableViewDataManager.swift
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

class TableViewDataManager<T: UITableViewCell, U>: NSObject, UITableViewDataSource {
    
    private var cellIdentifierAtIndexPath: ((IndexPath) -> (String))?
    private var cellConstructor: ((T, U, IndexPath) -> ())?
    
    private var _sections = [SectionData<U>]([SectionData(title: "", items: [])])
    
    private weak var tableView: UITableView?
    
    var insertAnimation = UITableViewRowAnimation.automatic
    var deleteAnimation = UITableViewRowAnimation.automatic
    var reloadSectionAnimation = UITableViewRowAnimation.automatic
    
    func setup(cellIdentifierAtIndexPath: @escaping ((IndexPath) -> (String)), cellConstructor: @escaping ((T, U, IndexPath) -> ())) -> Self {
        self.cellIdentifierAtIndexPath = cellIdentifierAtIndexPath
        self.cellConstructor = cellConstructor
        return self
    }
    
    func setup(cellIdentifier: String, cellConstructor: @escaping ((T, U, IndexPath) -> ())) -> Self {
        self.cellIdentifierAtIndexPath = { _ in cellIdentifier }
        self.cellConstructor = cellConstructor
        return self
    }
    
    func bindTo(_ tableView: UITableView) {
        tableView.dataSource = self
        self.tableView = tableView
    }
    
    private func updateTableView(exec: (UITableView) -> ()) {
        guard let tableView = tableView else {
            return
        }
        tableView.beginUpdates()
        exec(tableView)
        tableView.endUpdates()
    }
    
    // item1つ
    func append(_ item: U, section: Int = 0) {
        _sections[section].items.append(item)
        let indexPath = IndexPath(row: self._sections[section].items.count - 1, section: section)
        updateTableView { tableView in
            tableView.insertRows(at: [indexPath], with: insertAnimation)
        }
    }
    func insert(_ item: U, row: Int, section: Int = 0) {
        _sections[section].items.insert(item, at: row)
        updateTableView { tableView in
            tableView.insertRows(at: [IndexPath(row: row, section: section)], with: insertAnimation)
        }
    }
    func insert(_ item: U, indexPath: IndexPath) {
        self.insert(item, row: indexPath.row, section: indexPath.section)
    }
    func delete(at indexPath: IndexPath) {
        _sections[indexPath.section].items.remove(at: indexPath.row)
        updateTableView { tableView in
            tableView.deleteRows(at: [indexPath], with: deleteAnimation)
        }
    }
    func delete(row: Int, section: Int = 0) {
        self.delete(at: IndexPath(row: row, section: section))
    }
    
    // itemの配列(itemをまとめて)
    func append(contentsOf items: [U], section: Int = 0) {
        let maxIndex = self._sections[section].items.count
        _sections[section].items += items
        let indexPaths = (maxIndex..<(maxIndex+items.count)).map { IndexPath(row: $0, section: section) }
        updateTableView { tableView in
            tableView.insertRows(at: indexPaths, with: insertAnimation)
        }
    }
    func insert(contentsOf items: [U], at row: Int, section: Int = 0) {
        _sections[section].items.insert(contentsOf: items, at: row)
        let indexPaths = (row..<(row+items.count)).map { IndexPath(row: $0, section: section) }
        updateTableView { tableView in
            tableView.insertRows(at: indexPaths, with: insertAnimation)
        }
    }
    
    // delete [IndexPath] に対応したい
    
    // sectionまるごと
    func setTitle(_ title: String, section: Int = 0) {
        _sections[section].title = title
        tableView?.reloadSectionIndexTitles()
    }
    func setItems(_ items: [U], section: Int = 0) {
        _sections[section].items = items
        updateTableView { tableView in
            tableView.reloadSections([section], with: reloadSectionAnimation)
        }
    }
    func insert(_ sectionData: SectionData<U>, at section: Int) {
        _sections.insert(sectionData, at: section)
        updateTableView { tableView in
            tableView.insertSections([section], with: insertAnimation)
        }
    }
    func append(_ sectionData: SectionData<U>) {
        _sections.append(sectionData)
        updateTableView { tableView in
            tableView.insertSections([_sections.count - 1], with: insertAnimation)
        }
    }
    func delete(section: Int) {
        _sections.remove(at: section)
        updateTableView { tableView in
            tableView.deleteSections([section], with: deleteAnimation)
        }
    }
    
    func removeAll() {
        _sections = [SectionData<U>]([SectionData(title: "", items: [])])
        tableView?.reloadData()
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
