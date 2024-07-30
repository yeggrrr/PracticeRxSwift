//
//  ObservableExampleViewController.swift
//  PracticeRxSwift
//
//  Created by YJ on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa

class ObservableExampleViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
    let itemsB = [2.3, 2.0, 1.3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        just()
        of()
        from()
        take()
    }
    
    // element Parameter로 하나의 값을 받아 Observable을 Return
    // 하나의 값만 Emit
    func just() {
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just error - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
    
    // element Parameters가 가변 파라미터 선언되어 있어 여러가지의 값을 동시에 전달 가능
    // 2개 이상의 값을 Emit
    func of() {
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of error - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
    }
    
    // 배열의 각 요소를 Emit하고 싶을 때 사용
    // array Parameters로 배열을 받고, 배열의 각 element를 Observable로 Return
    func from() {
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from error - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    // 방출된 아이템 중 처음 n개의 아이템을 내보냄
    func take() {
        Observable.repeatElement("Yegr")
            .take(7)
            .subscribe { value in
                print("take - \(value)")
            } onError: { error in
                print("take error - \(error)")
            } onCompleted: {
                print("take completed")
            } onDisposed: {
                print("take disposed")
            }
            .disposed(by: disposeBag)
    }
}
