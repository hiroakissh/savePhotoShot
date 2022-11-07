//
//  SignUpViewModel.swift
//  savePhotoShot
//
//  Created by HiroakiSaito on 2022/11/07.
//

import Foundation
import UIKit
import RxSwift

class SignUpViewModel {
    let validationText: Observable<String>
    let validationColor: Observable<UIColor>
    let validationButton: Observable<Bool>

    init(emailTextObservable: Observable<String?>,
         passwordTextObservable: Observable<String?>,
         confirmPasswordTextObservable: Observable<String?>,
         model: SignUpModelProtocol) {

        let event = Observable
            .combineLatest(
                emailTextObservable,
                passwordTextObservable,
                confirmPasswordTextObservable
            )
            .skip(1)
            .flatMap { emailText, passwordText, confirmPasswordText -> Observable<Event<Void>> in
                return model
                    .validate(
                        emailText: emailText,
                        passwordText: passwordText,
                        confirmPassword: confirmPasswordText
                    )
                    .materialize()
            }
            .share()

        self.validationText = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next: return .just("登録可能です！")
                case let .error(error as SignUpModelError):
                    return .just(error.errorText)
                case .error, .completed: return .empty()
                }
            }
            .startWith("EmailとPassWordを入力してください")

        self.validationColor = event
            .flatMap { event -> Observable<UIColor> in
                switch event {
                case .next: return .just(.green)
                case .error: return .just(.red)
                case .completed: return .empty()
                }
            }

        self.validationButton = event
            .flatMap{ event -> Observable<Bool> in
                switch event {
                case .next: return .just(true)
                case .error: return .just(false)
                case .completed: return .empty()
                }
            }
    }
}

extension SignUpModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidEmailAndPassword:
            return "EmailとPasswordが未入力です"
        case .invalidEmail:
            return "Emailが正しくないです"
        case .invalidPassword:
            return "Passwordは8文字以上にしてください"
        case .invalidSamePassword:
            return "確認用のPasswordが正しくありません"
        }
    }
}
