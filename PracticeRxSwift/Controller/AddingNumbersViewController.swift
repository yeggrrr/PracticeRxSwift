//
//  AddingNumbersViewController.swift
//  PracticeRxSwift
//
//  Created by YJ on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class AddingNumbersViewController: UIViewController, ViewRepresentable {
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    private let plusLabel = UILabel()
    private let resultLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        calculator()
    }
    
    func addSubviews() {
        view.addSubviews([number1, number2, number3, plusLabel, resultLabel])
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        number1.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(200)
            $0.leading.equalTo(safeArea).offset(100)
            $0.trailing.equalTo(safeArea).offset(-80)
            $0.height.equalTo(30)
        }
        
        number2.snp.makeConstraints {
            $0.top.equalTo(number1.snp.bottom).offset(10)
            $0.leading.equalTo(safeArea).offset(100)
            $0.trailing.equalTo(safeArea).offset(-80)
            $0.height.equalTo(30)
        }
        
        number3.snp.makeConstraints {
            $0.top.equalTo(number2.snp.bottom).offset(10)
            $0.leading.equalTo(safeArea).offset(100)
            $0.trailing.equalTo(safeArea).offset(-80)
            $0.height.equalTo(30)
        }
        
        plusLabel.snp.makeConstraints {
            $0.centerY.equalTo(number3.snp.centerY)
            $0.trailing.equalTo(number3.snp.leading).offset(-5)
            $0.height.equalTo(number3.snp.height)
            $0.width.equalTo(20)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(number3.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeArea).inset(80)
            $0.height.equalTo(30)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        [number1, number2, number3].forEach {
            $0.backgroundColor = .systemGray6
            $0.keyboardType = .numberPad
            $0.textAlignment = .left
        }
        
        plusLabel.text = "+"
        plusLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        resultLabel.backgroundColor = .systemGray4
    }
    
    private func calculator() {
        Observable.combineLatest(
            number1.rx.text.orEmpty,
            number2.rx.text.orEmpty,
            number3.rx.text.orEmpty) { value1, value2, value3 -> Int in
                return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
            }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
