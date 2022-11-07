//
//  SignUpViewController.swift
//  savePhotoShot
//
//  Created by HiroakiSaito on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var validPasswordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var validateTextView: UITextView!

    private lazy var viewModel = SignUpViewModel(
        emailTextObservable: emailTextField.rx.text.asObservable(),
        passwordTextObservable: passwordTextField.rx.text.asObservable(),
        confirmPasswordTextObservable: validPasswordTextField.rx.text.asObservable(),
        model: SignUpModel()
    )

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.isEnabled = false

        viewModel.validationText
            .bind(to: validateTextView.rx.text)
            .disposed(by: disposeBag)

        viewModel.validationColor
            .bind(to: validateTextColor)
            .disposed(by: disposeBag)

        viewModel.validationButton
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    private var validateTextColor: Binder<UIColor> {
        return Binder(self) { vc, color in
            vc.validateTextView.textColor = color
        }
    }
}
