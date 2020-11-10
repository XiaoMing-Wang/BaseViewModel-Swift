//
//  WXMBaseNetworkHandler.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/5/23.
//  Copyright © 2020 wq. All rights reserved.
//

import UIKit
import Foundation

enum WXMRefreshType: Int {
    case freedom = 0          /** 自由状态 */
    case headerControl = 1    /** 头部 */
    case footControl = 2      /** 尾部 */
}

private var networkHandler: Void?
class WXMBaseNetworkHandler: NSObject {

    /** 页码 */
    var lastPage: Int = 1
    var currentPage: Int = 1
    var isRequestting: Bool?
    var refreshType: WXMRefreshType?
    var dataSource: [Any] = []
    weak var controller: UIViewController?

    convenience init(delegate: UIViewController) {
        self.init()
        lastPage = 1
        currentPage = 1
        refreshType = .freedom
        isRequestting = false
        dataSource = []
        self.controller = delegate
        initializationVariable()
    }

    /** 设置默认数据 子类设置 */
    func initializationVariable() { }

    /** 请求头部 */
    func pullRefreshHeaderControl() {
        if refreshType == .headerControl { return }
        refreshType = .headerControl
        lastPage = 1
        currentPage = 1
        isRequestting = true
    }
    
    /** 请求尾部 */
    func pullRefreshFootControl() {
        if refreshType == .footControl { return }
        refreshType = .footControl
        currentPage += 1
        isRequestting = true
    }

    /** 刷新成功 */
    func pullRefreshSuccess() {
        if refreshType == .footControl {
            lastPage = currentPage
        } else {
            lastPage = 1
            currentPage = 1
        }

        refreshType = .freedom
        isRequestting = false
    }

    /** 刷新失败 */
    func pullRefreshFail() {
        if refreshType == .footControl {
            currentPage = lastPage
        } else {
            lastPage = 1
            currentPage = 1
        }
        refreshType = .freedom
        isRequestting = false
    }
}
