//
//  SideMenuViewController.swift
//  SideMenuExample
//
//  Created by Phuc Nguyen on 2024-09-24.
//

import UIKit

class SideMenuViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Side Menu"
        label.font = .systemFont(ofSize: kWelcomeFontSize)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        layout()
    }
    
    private func customizeUI() {
        view.backgroundColor = .systemTeal
        view.addSubview(titleLabel)
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
