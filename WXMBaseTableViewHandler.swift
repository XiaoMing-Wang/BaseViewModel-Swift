//
//  WXMBaseTableViewHandler.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/5/23.
//  Copyright © 2020 wq. All rights reserved.
//

import UIKit
import Foundation

protocol WXMTableViewHandleProtocol: NSObjectProtocol {
    func wt_scrollViewDidScroll()
    func wt_scrollViewWillBeginDragging()
    func wt_scrollViewDidEndDecelerating()
    func wt_scrollViewWillBeginDecelerating()
    func wt_tableViewDidSelectRowAtIndexPath(indexPath: IndexPath)
    func wt_scrollViewDidEndDraggingWithDecelerate(decelerate: Bool)
    func wt_tableCustomEvent(event: String, object: Any?)
}

extension WXMTableViewHandleProtocol {
    func wt_scrollViewDidScroll() { }
    func wt_scrollViewWillBeginDragging() { }
    func wt_scrollViewDidEndDecelerating() { }
    func wt_scrollViewWillBeginDecelerating() { }
    func wt_tableViewDidSelectRowAtIndexPath(indexPath: IndexPath) { }
    func wt_scrollViewDidEndDraggingWithDecelerate(decelerate: Bool) { }
    func wt_tableCustomEvent(event: String, object: Any?) { }
}

private var tableViewHandler: Void?
class WXMBaseTableViewHandler: NSObject, UITableViewDelegate, UITableViewDataSource {

    /// 参数
    var dataSource: [Any] = []
    weak var tableView: UITableView?
    weak var controller: UIViewController?
    weak var delegate: WXMTableViewHandleProtocol?
 
    public init(delegate: WXMTableViewHandleProtocol) {
        super.init()
        self.delegate = delegate
        self.dataSource = []
        if delegate.isKind(of: UIViewController.self) {
            controller = delegate as? UIViewController
        }
        initializationVariable()
    }

    /** 设置默认数据 子类设置 */
    public func initializationVariable() { }

    /** setTable */
    public func setTable(_ tableView: UITableView, cellClass: AnyClass?) {
        setTable(tableView, dataSource: [], cellClass: cellClass)
    }

    /** setTable */
    public func setTable(_ tableView: UITableView, dataSource: [Any], cellClass: AnyClass? = nil) {
        self.dataSource = dataSource
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        if cellClass != nil {
            self.tableView?.register(cellClass!, forCellReuseIdentifier: "cell")
        }
    }

    func setDataSourceAndReload(dataSource: [Any]) {
        self.dataSource = dataSource
        self.tableView?.reloadData()
    }

    //MARK: -------------------------------- tableView delegate
    /** numberOfSections不能重载 */
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.wt_tableViewDidSelectRowAtIndexPath(indexPath: indexPath)
    }

    //MARK: -------------------------------- scrollView delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.wt_scrollViewDidScroll()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.wt_scrollViewWillBeginDragging()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.wt_scrollViewDidEndDraggingWithDecelerate(decelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.wt_scrollViewWillBeginDecelerating()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.wt_scrollViewDidEndDecelerating()
    }
    
    /** 获取组数量 */
    func sectionCount() -> Int {
        return max(self.tableView?.numberOfSections ?? 0, 0)
    }

    func rowCountOfSetion(_ section: Int) -> Int {
        return max(self.tableView?.numberOfRows(inSection: section) ?? 0, 0)
    }

}

/** 分组 */
class WXMGroupTableViewHandler: WXMBaseTableViewHandler {

    override func numberOfSections() -> Int {
        dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = dataSource[section] as? [Any] {
            return section.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
}
