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
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        setPickerView()
    }
    
    func addSubviews() {
        view.addSubviews([simplePickerView, simpleLabel])
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
    }
    
    func configureUI() {
        simpleLabel.backgroundColor = .systemBrown
        simplePickerView.backgroundColor = .systemGray
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
}

