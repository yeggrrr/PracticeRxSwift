//
//  ValidationViewController.swift
//  PracticeRxSwift
//
//  Created by YJ on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ValidationViewController: UIViewController, ViewRepresentable {
    private let userNameLabel = UILabel()
    private let userNameTextField = UITextField()
    private let userNameValidLabel = UILabel()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordValidLabel = UILabel()
    private let checkButton = UIButton()
    
    private let minimalUsernameLength = 5
    private let minimalPasswordLength = 5
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
        configureUI()
        validation()
    }
    
    func addSubviews() {
        view.addSubviews([userNameLabel, userNameTextField, userNameValidLabel])
        view.addSubviews([passwordLabel, passwordTextField, passwordValidLabel])
        view.addSubview(checkButton)
    }
    
    func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(50)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(25)
        }
        
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(40)
        }
        
        userNameValidLabel.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(30)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(userNameValidLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(25)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(40)
        }
        
        passwordValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(30)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(passwordValidLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeArea).inset(20)
            $0.height.equalTo(50)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        userNameLabel.text = "UserName"
        passwordLabel.text = "Password"
        userNameLabel.font = .systemFont(ofSize: 17, weight: .regular)
        passwordLabel.font = .systemFont(ofSize: 17, weight: .regular)
        
        [userNameTextField, passwordTextField].forEach {
            $0.backgroundColor = .systemGray6
            $0.textAlignment = .left
        }
        
        [userNameValidLabel, passwordValidLabel].forEach {
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textColor = .systemRed
        }
        
        userNameValidLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        checkButton.backgroundColor = .systemGreen
        checkButton.setTitle("Do Something", for: .normal)
    }
    
    func validation() {
        let userNameValid = userNameTextField.rx.text.orEmpty
            .map { $0.count >= self.minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= self.minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(userNameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        userNameValid.bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        userNameValid.bind(to: userNameValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid.bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        everythingValid.bind(to: checkButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        checkButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
}
