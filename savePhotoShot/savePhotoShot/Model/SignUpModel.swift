//
//  SignUpModel.swift
//  savePhotoShot
//
//  Created by HiroakiSaito on 2022/11/07.
//

import Foundation
import RxSwift

enum SignUpModelError: Error {
    case invalidEmail
    case invalidPassword
    case invalidSamePassword
    case invalidEmailAndPassword
}

protocol SignUpModelProtocol {
    func validate(emailText: String?, passwordText: String?, confirmPassword: String?) -> Observable<Void>
}

final class SignUpModel: SignUpModelProtocol {
    func validate(emailText: String?, passwordText: String?, confirmPassword: String?) -> RxSwift.Observable<Void> {
        guard let emailText = emailText,
              let passwordText = passwordText,
              let confirmPassword = confirmPassword
        else {
            return Observable.error(SignUpModelError.invalidEmailAndPassword)
        }

        if !validateEmail(candidate: emailText) {
            return Observable.error(SignUpModelError.invalidEmail)
        }

        if passwordText.count < 8 {
            return Observable.error(SignUpModelError.invalidPassword)
        }

        if passwordText != confirmPassword {
            return Observable.error(SignUpModelError.invalidSamePassword)
        }

        return Observable.just(())
    }

    private func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
}
