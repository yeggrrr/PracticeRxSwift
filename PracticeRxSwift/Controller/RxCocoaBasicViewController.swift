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
    let simpleSwitch = UISwitch()
    let signNameTextField = UITextField()
    let signEmailTextField = UITextField()
    let signButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        setPickerView()
        setTableView()
        setSign()
        setSwitch()
    }
    
    func addSubviews() {
        view.addSubviews([
            simplePickerView,
            simpleLabel,
            simpleTableView,
            simpleSwitch,
            signNameTextField,
            signEmailTextField,
            signButton
        ])
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
        
        signNameTextField.snp.makeConstraints {
            $0.top.equalTo(simpleTableView.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(50)
        }
        
        signEmailTextField.snp.makeConstraints {
            $0.top.equalTo(signNameTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(50)
        }
        
        signButton.snp.makeConstraints {
            $0.top.equalTo(signEmailTextField.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(50)
            $0.height.equalTo(40)
        }
        
        simpleSwitch.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).offset(-20)
            $0.centerX.equalTo(safeArea.snp.centerX)
        }
    }
    
    func configureUI() {
        simpleLabel.backgroundColor = .systemBrown
        simpleLabel.textAlignment = .center
        simplePickerView.backgroundColor = .systemGray
        simpleTableView.backgroundColor = .darkGray
        
        signNameTextField.backgroundColor = .white
        signNameTextField.textAlignment = .center
        signEmailTextField.backgroundColor = .white
        signEmailTextField.textAlignment = .center
        signButton.backgroundColor = .systemIndigo
        signButton.setTitle("버튼입니다. 클릭해주세요.", for: .normal)
        
        simpleSwitch.onTintColor = .systemPink
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
    
    func setSwitch() {
        Observable.of(true)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        Observable.combineLatest(signNameTextField.rx.text.orEmpty, signEmailTextField.rx.text.orEmpty) { name, email in
            return "이름은 \(name)이고, 이메일은 \(email)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signNameTextField.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmailTextField.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmailTextField.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
}
