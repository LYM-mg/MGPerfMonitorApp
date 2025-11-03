//
//  sdaViewController.swift
//  MGPerfMonitorApp
//
//  Created by 刘远明 on 2025/11/3.
//

import UIKit
import JXSegmentedView
import JXPagingView

class OuterPagingViewController: UIViewController {
    private var pagingView: JXPagingListRefreshView!
    private let titles = ["心动推荐", "初来乍到"]

    private lazy var titleDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.titles = titles
        ds.titleNormalColor = .gray
        ds.titleSelectedColor = .black
        ds.titleNormalFont = .systemFont(ofSize: 15)
        ds.titleSelectedFont = .boldSystemFont(ofSize: 16)
        return ds
    }()

    private lazy var segmentedView: JXSegmentedView = {
        let sv = JXSegmentedView()
        sv.dataSource = titleDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorHeight = 2
        sv.indicators = [indicator]
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        pagingView = JXPagingListRefreshView(delegate: self)
        view.addSubview(pagingView)
        pagingView.frame = view.bounds
        pagingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // 这里需要做一次类型转换为协议存在体 (any JXSegmentedViewListContainer)
        // pagingView.listContainerView 是 JXPagingListContainerView
        // 把它转换为 any JXSegmentedViewListContainer
        segmentedView.listContainer = pagingView.listContainerView as? (any JXSegmentedViewListContainer)
    }

    deinit {
        pagingView = nil
    }
}

// MARK: - JXPagingViewDelegate (外层)
extension OuterPagingViewController: JXPagingViewDelegate {
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        header.backgroundColor = .systemPink
        return header
    }

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 200
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 44
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            return InnerPagingListViewController()
        } else {
            return SimpleListViewController(title: titles[index])
        }
    }
}
