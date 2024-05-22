//
//  ViewController.swift
//  CombineTasksUIKit
//
//  Created by Anastasiya Omak on 20/05/2024.
//

import UIKit
import Combine

class PipeLineView: UIViewController {
    
    private let pipeLineViewModel = PipeLineViewModel()
    private var anyCancellable: AnyCancellable?
    private var anyCancellableSecond: AnyCancellable?
    
    private let nameTextField = {
        let textField = UITextField()
        textField.placeholder = "Your name"
        textField.frame = CGRect(x: 50, y: 400, width: 200, height: 40)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.frame = CGRect(x: 260, y: 395, width: 100, height: 50)
        return label
    }()
    
    private let surnameTextField = {
        let textField = UITextField()
        textField.placeholder = "Your surname"
        textField.frame = CGRect(x: 50, y: 450, width: 200, height: 40)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let surnameLabel = {
        let label = UILabel()
        label.frame = CGRect(x: 260, y: 445, width: 100, height: 50)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupValidationName()
        setupValidationSurname()
    }
    
    private func setupViews() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(nameLabel)
        view.addSubview(surnameLabel)
    }
    
    private func setupValidationName() {
        anyCancellable = pipeLineViewModel.$validatorName
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: nameLabel)
    }
    
    private func setupValidationSurname() {
        anyCancellableSecond = pipeLineViewModel.$validatorSurname
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: surnameLabel)
    }
}

extension PipeLineView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            pipeLineViewModel.name = string
        } else {
            pipeLineViewModel.surname = string
        }
        return true
    }
}
