//
//  SimpleListViewController.swift
//  MGPerfMonitorApp
//
//  Created by 刘远明 on 2025/11/3.
//

import UIKit
import JXPagingView

class SimpleListViewController: UIViewController {
    private let tableView = UITableView()
    private let titleText: String
    // 存储从父级注入的回调
    private var listScrollCallback: ((UIScrollView) -> Void)?

    init(title: String) {
        self.titleText = title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

// MARK: - JXPagingViewListViewDelegate
extension SimpleListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listScrollView() -> UIScrollView {
        return tableView
    }

    // 父级会通过这个接口把回调注入进来（或覆盖之前的回调）
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        self.listScrollCallback = callback
    }
}

// MARK: - UITableViewDataSource & Delegate
extension SimpleListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 30 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        cell.textLabel?.text = "\(titleText) - Row \(indexPath.row)"
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 每次子列表滚动时，主动把滚动信息上报（如果父级注入了回调）
        listScrollCallback?(scrollView)
    }
}
