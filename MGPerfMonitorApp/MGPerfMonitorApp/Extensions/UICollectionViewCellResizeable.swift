//
//  UICollectionViewCellResizeable.swift
//  ChiefMT
//
//  Created by james_kong on 2/6/2022.
//

import UIKit

protocol UICollectionViewCellResizeable: AnyObject {
    func sizeOf(string: String) -> CGSize
}
