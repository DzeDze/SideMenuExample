//
//  MainMenuViewController.swift
//  SideMenuExample
//
//  Created by Phuc Nguyen on 2024-09-24.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MainView"
        label.font = .systemFont(ofSize: kWelcomeFontSize)
        label.textColor = .systemTeal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var burgerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: [])
        button.tintColor = .systemTeal
        button.addTarget(self, action: #selector(burgerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var sideMenuVC: SideMenuViewController = {
        let sideMenu = SideMenuViewController()
        return sideMenu
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    private weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    private var isExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        layout()
        setupSwipeGesture()
    }
    
    private func customizeUI() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(burgerButton)
        view.addSubview(dimmingView)
        
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: self)
        
        sideMenuVC.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        
        //layout contentView
        contentViewLeadingConstraint = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        NSLayoutConstraint.activate([
            contentViewLeadingConstraint,
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        //layout view titleLabel and burgerButton (the one that used to open sideMenu)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            burgerButton.topAnchor.constraint(equalToSystemSpacingBelow: contentView.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            burgerButton.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2)
        ])
        
        //layout dimmingView
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set up sideMenuVC constraints
        sideMenuLeadingConstraint = sideMenuVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -kSideMenuWidth) // Initially off-screen
        NSLayoutConstraint.activate([
            sideMenuLeadingConstraint,
            sideMenuVC.view.widthAnchor.constraint(equalToConstant: kSideMenuWidth),
            sideMenuVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenuVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSwipeGesture() {
        // Add a swipe gesture recognizer for swiping from the left edge to show the menu
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
}

//MARK: - control views
extension MainViewController {
    @objc private func burgerButtonTapped() {
        if isExpanded {
            hideSideMenu()
        } else {
            showSideMenu()
        }
    }
    
    @objc func handleTapOutside() {
        if isExpanded {
            hideSideMenu()
        }
    }
    
    func showSideMenu() {
        isExpanded = true
        animateSideMenu(targetPosition: kSideMenuWidth, completion: { _ in
            self.dimmingView.isUserInteractionEnabled = true
        })
    }
    
    // Hide the side menu
    func hideSideMenu() {
        isExpanded = false
        animateSideMenu(targetPosition: 0, completion: { _ in
            self.dimmingView.isUserInteractionEnabled = false
        })
    }
    
    
}

//MARK: - Side Menu animation
extension MainViewController {
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            // Update the side menu leading constraint to show or hide it
            self.sideMenuLeadingConstraint.constant = targetPosition == 0 ? -kSideMenuWidth : 0
            
            // Move the content view by adjusting its leading constraint
            self.contentViewLeadingConstraint.constant = targetPosition
            
            // Animate dimming view's visibility
            self.dimmingView.alpha = self.isExpanded ? 1 : 0
            
            self.view.layoutIfNeeded()
            
        }, completion: completion)
    }
}

//MARK: - Handle pan gesture
extension MainViewController {
    @objc func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began, .changed:
            if translation.x <= kSideMenuWidth && translation.x >= 0 {
                // Move sideMenu and dimming view according to the swipe progress
                sideMenuLeadingConstraint.constant = -kSideMenuWidth + translation.x
                contentViewLeadingConstraint.constant = translation.x
                dimmingView.alpha = translation.x / kSideMenuWidth
                view.layoutIfNeeded()
            }
            
        case .ended:
            // Decide whether to show or hide the menu based on swipe completion
            if translation.x > kSideMenuWidth / 2 {
                showSideMenu()
            } else {
                hideSideMenu()
            }
            
        default:
            break
        }
    }
}
