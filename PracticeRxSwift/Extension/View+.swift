//
//  View+.swift
//  PracticeRxSwift
//
//  Created by YJ on 7/31/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
