//
//  SignUpViewController.swift
//  savePhotoShot
//
//  Created by HiroakiSaito on 2022/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class TestSignUpViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var errorTextView: UITextView!
    @IBOutlet private weak var signUpButton: UIButton!

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let inputs = Observable
            .combineLatest(
                emailTextField.rx.text.map { $0 ?? "" },
                passwordTextField.rx.text.map { $0 ?? "" },
                confirmPasswordTextField.rx.text.map { $0 ?? ""}
            )

        errorTextView.textColor = .red

        inputs
            .map { email, pass1, pass2 in
                email.isValidEmail
                && pass1.isValidPassword
                && pass2.isValidPassword
                && pass1 == pass2
            }
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)

        inputs
            .map { email, pass1, pass2 in
                return self.makeErrorsMessages(email: email, password: pass1, confirmPassword: pass2)
                    .map { "・\($0)" }
                    .joined(separator: "\n")
            }
            .bind(to: errorTextView.rx.text)
            .disposed(by: disposeBag)
    }

    private func makeErrorsMessages(email: String, password: String, confirmPassword: String) -> [String] {
        var message: [String] = []

        if email.isEmpty {
            message.append("メールアドレスを入力してください")
        } else if !email.isValidEmail {
            message.append("メールアドレスが正しい形式ではありません")
        }

        if password.isEmpty {
            message.append("パスワードを入力してください")
        } else if !password.isValidPassword {
            message.append("パスワードの形式が正しくありません")
        }

        if confirmPassword.isEmpty {
            message.append("パスワードを入力してください")
        } else if !confirmPassword.isValidPassword {
            message.append("パスワードの形式が正しくありません")
        }

        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
            message.append("確認用のパスワードが正しくありません")
        }

        return message
    }
}

private extension String {
    var isValidEmail: Bool {
        self.contains("@gmail.com")
    }

    var isValidPassword: Bool {
        self.count >= 8
    }
}
