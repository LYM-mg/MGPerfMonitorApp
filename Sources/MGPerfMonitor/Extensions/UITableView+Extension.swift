//
// UITableView+Extension.swift
//
// Copyright © 2022 Chief Group Limited. All rights reserved.
//

import UIKit

extension UITableView {

//    func registerCellsFromNib(nibs: [CHFReusableCell.Type]) {
//
//        nibs.forEach {
//
//            self.register(UINib(nibName: String(describing: $0.self), bundle: nil), forCellReuseIdentifier: $0.defaultReuseIdentifier)
//        }
//    }
//
//    func registerHeaderFooterCellsFromNib(nibs: [CHFReusableCell.Type]) {
//
//        nibs.forEach {
//
//            self.register(UINib(nibName: String(describing: $0.self), bundle: nil), forHeaderFooterViewReuseIdentifier: $0.defaultReuseIdentifier)
//        }
//    }

//    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T? {
//        
//        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
//            
//            assertionFailure("Cannot dequeue cell with identifier: \(T.defaultReuseIdentifier)")
//            return nil
//        }
//        
//        return cell
//    }
//    
//    func dequeueReusableHeaderFooterCell<T: UITableViewHeaderFooterView>() -> T? {
//
//        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
//
//            assertionFailure("Cannot dequeue header/footer cell with identifier: \(T.defaultReuseIdentifier)")
//            return nil
//        }
//        
//        return cell
//    }

    func cellForRow<T: UITableViewCell>(at indexPath: IndexPath) -> T? {

        guard let cell = cellForRow(at: indexPath) as? T else {

            return nil
        }

        return cell
    }

    func hideInfiniteEmptyCell() {

        tableFooterView = UIView()
    }

    func indexPathForView(_ view: UIView) -> IndexPath? {

        let center = view.center
        let viewCenter = convert(center, from: view.superview)
        let indexPath = indexPathForRow(at: viewCenter)
        return indexPath
    }

    func lastIndexpath() -> IndexPath {

        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)

        return IndexPath(row: row, section: section)
    }
}
