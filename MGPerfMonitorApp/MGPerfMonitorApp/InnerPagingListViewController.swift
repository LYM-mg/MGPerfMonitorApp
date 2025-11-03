//
//  InnerPagingListViewController.swift
//  MGPerfMonitorApp
//
//  Created by 刘远明 on 2025/11/3.
//

import UIKit
import JXSegmentedView
import JXPagingView

class InnerPagingListViewController: UIViewController {
    private let innerTitles = ["推荐1","推荐2","推荐3","推荐4","推荐5","推荐6"]
    private var pagingView: JXPagingView!
    // 保存外层注入的回调，转发给内部每个 list
    private var outerListScrollCallback: ((UIScrollView) -> Void)?

    private lazy var titleDataSource: JXSegmentedTitleDataSource = {
        let ds = JXSegmentedTitleDataSource()
        ds.titles = innerTitles
        ds.titleNormalColor = .gray
        ds.titleSelectedColor = .black
        ds.titleNormalFont = .systemFont(ofSize: 14)
        ds.titleSelectedFont = .boldSystemFont(ofSize: 15)
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

        pagingView = JXPagingView(delegate: self)
        view.addSubview(pagingView)
        pagingView.frame = view.bounds
        pagingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        segmentedView.listContainer = pagingView.listContainerView as? (any JXSegmentedViewListContainer)
    }

    deinit { pagingView = nil }
}

// MARK: - 作为外层 list：转发滚动回调
extension InnerPagingListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listScrollView() -> UIScrollView {
        // 外层需要内层 paging 的 mainTableView 来计算吸顶/滚动同步
        return pagingView.mainTableView
    }

    // 外层会把回调注入到这里，这里把回调保存在 outerListScrollCallback，
    // 并在创建每个内部 list 的时候把它注入给子 list（见下面 initListAt）
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        outerListScrollCallback = callback
    }
}

// MARK: - 作为内层 paging 的 delegate：提供 pin header / 子列表等
extension InnerPagingListViewController: JXPagingViewDelegate {
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return UIView(frame: .zero)
    }

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 0
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 44
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return innerTitles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        // 为每个子 list 注入外层的滚动回调（如果有）
        let list = SimpleListViewController(title: innerTitles[index])
        if let outerCB = outerListScrollCallback {
            // SimpleListViewController 实现了 listViewDidScrollCallback(_:)
            list.listViewDidScrollCallback { scrollView in
                // 子列表滚动时，先触发外层的回调，供 outer JXPagingView 使用
                outerCB(scrollView)
            }
        }
        return list
    }
}
