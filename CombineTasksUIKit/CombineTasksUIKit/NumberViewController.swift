//
//  NumberViewController.swift
//  CombineTasksUIKit
//
//  Created by Anastasiya Omak on 22/05/2024.
//

import UIKit
import Combine

class NumberViewController: UIViewController {
    
    private var textField: UITextField = {
          let textField = UITextField()
          textField.borderStyle = .roundedRect
          textField.translatesAutoresizingMaskIntoConstraints = false
         return textField
      }()
    
    private var checkButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Проверить простоту числа", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = .yellow
           return button
        }()
    
    private var primeNumberLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .green
           label.font = .systemFont(ofSize: 15, weight: .bold)
           return label
       }()
    
    var viewModel = NumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    func setupUI() {
            view.addSubview(primeNumberLabel)
            view.addSubview(textField)
            view.addSubview(checkButton)

            checkButton.addTarget(self, action: #selector(check), for: .touchUpInside)

            NSLayoutConstraint.activate([
                textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
                textField.widthAnchor.constraint(equalToConstant: 200),
                textField.heightAnchor.constraint(equalToConstant: 50),

                checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                checkButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
                checkButton.widthAnchor.constraint(equalToConstant: 240),
                checkButton.heightAnchor.constraint(equalToConstant: 40),

                primeNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                primeNumberLabel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 20),
                primeNumberLabel.widthAnchor.constraint(equalToConstant: 220),
                primeNumberLabel.heightAnchor.constraint(equalToConstant: 50)
                   ])
        }
    
    func bind() {
            let subscriber = Subscribers.Assign(object: primeNumberLabel, keyPath: \.text)
        viewModel.$textToShow.subscribe(subscriber)

            textField.textFieldPublisher
                .sink { [unowned self] text in
                    viewModel.textFieldText = text
                }
                .store(in: &viewModel.subscriptions)
        }
    
    @objc func check() {
        viewModel.check()
    }
    
    
}

extension UITextField {
    
    var textFieldPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text}
            .eraseToAnyPublisher()
    }
}



enum PrimeCheckingError: String, Error, Identifiable {
    var id: String { rawValue }
    case castingFailed = "Нельзя приобразовать String в Int"
}


class NumberViewModel: ObservableObject {
    @Published var textFieldText = ""
    @Published var textToShow: String? = ""

    var subscriptions: Set<AnyCancellable> = []
    
    func checkPrimeNumber() -> AnyPublisher<Bool, PrimeCheckingError> {
        Deferred {
            Future { [unowned self] promise in
                guard let number = Int(self.textFieldText) else { promise(.failure(.castingFailed))
                    return
                }
                if isPrime(number) {
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func check() {
        checkPrimeNumber()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [unowned self] value in
                showDescription(isPrime: value)
            }
            .store(in: &subscriptions)
    }

    func isPrime(_ number: Int) -> Bool {
        if number < 2 {
            return false
        }
        for i in 2..<number {
            if number % i == 0 {
                return false
            }
        }
        return true
    }

    func showDescription(isPrime: Bool) {
        if isPrime {
            textToShow = "\(textFieldText) - простое число"
        } else {
            textToShow = "\(textFieldText) - не простое число"
        }
    }

}

