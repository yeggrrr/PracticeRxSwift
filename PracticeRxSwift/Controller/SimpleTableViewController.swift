//
//  SimpleTableViewController.swift
//  PracticeRxSwift
//
//  Created by YJ on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewController: UIViewController, UITableViewDelegate {
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCell()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func configureCell() {
        let items = Observable.just((0..<20).map { "\($0)" } )
        
        items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = "\(element) @ row \(row)"
        }
        .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { value in
                self.tableViewShowAlert(message: "Tapped `\(value)`")
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                self.tableViewShowAlert(message: "Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
}
