//
//  TaxiViewController.swift
//  CombineTasksUIKit
//
//  Created by Anastasiya Omak on 22/05/2024.
//

import UIKit
import Combine

class TaxiViewController: UIViewController {
    
    var taxiViewModel = TaxiViewModel()
    
    private let dataLabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let statusLabel = {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        return label
    }()
    
    private let cancelButton = {
        let button = UIButton()
        button.setTitle("Отменить заказ", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let refreshButton = {
        let button = UIButton()
        button.setTitle("Заказать такси", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        let subscriber1 = Subscribers.Assign(object: dataLabel, keyPath: \.text)
        taxiViewModel.$message.subscribe(subscriber1)
        
        let subscriber2 = Subscribers.Assign(object: statusLabel, keyPath: \.text)
        taxiViewModel.$status.subscribe(subscriber2)
        
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(dataLabel)
        view.addSubview(statusLabel)
        view.addSubview(cancelButton)
        view.addSubview(refreshButton)
    }
    
    private func setupConstraints() {
        dataLabel.frame = CGRect(x: 40, y: 200, width: 300, height: 50)
        statusLabel.frame = CGRect(x: 70, y: 260, width: 250, height: 50)
        cancelButton.frame = CGRect(x: 100, y: 350, width: 200, height: 50)
        refreshButton.frame = CGRect(x: 100, y: 400, width: 200, height: 50)
    }
    
    @objc private func cancel() {
        taxiViewModel.cancel()
    }
    
    @objc private func refresh() {
        taxiViewModel.refresh()
    }
}



