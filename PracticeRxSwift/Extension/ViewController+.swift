//
//  ViewController+.swift
//  PracticeRxSwift
//
//  Created by YJ on 7/31/24.
//

import UIKit

extension UIViewController {
    func showAlert() {
        let alert = UIAlertController(title: "버튼이 클릭됐어요!", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
