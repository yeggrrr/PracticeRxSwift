//
//  RxCocoaBasicViewController.swift
//  PracticeRxSwift
//
//  Created by YJ on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class RxCocoaBasicViewController: UIViewController, ViewRepresentable {
    let simplePickerView = UIPickerView()
    let simpleLabel = UILabel()
    let simpleTableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        setPickerView()
        setTableView()
    }
    
    func addSubviews() {
        view.addSubviews([simplePickerView, simpleLabel, simpleTableView])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        simpleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(30)
        }
        
        simplePickerView.snp.makeConstraints {
            $0.top.equalTo(simpleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(100)
        }
        
        simpleTableView.snp.makeConstraints {
            $0.top.equalTo(simplePickerView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(150)
        }
    }
    
    func configureUI() {
        simpleLabel.backgroundColor = .systemBrown
        simpleLabel.textAlignment = .center
        simplePickerView.backgroundColor = .systemGray
        simpleTableView.backgroundColor = .darkGray
    }
    
    func setPickerView() {
        let items = Observable.just(["영화", "애니메이션", "드라마", "기타"])
        
        items.bind(to: simplePickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just(["First Item", "Second Item", "Third Item"])
        
        items.bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.backgroundColor = .darkGray
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다!"
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

