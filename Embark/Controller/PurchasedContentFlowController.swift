//
//  PurchasedContentFlowController.swift
//  Embark
//
//  Created by Emmanuoel Haroutunian on 1/8/18.
//  Copyright © 2018 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class PurchasedContentFlowController: UIViewController {
	// MARK: - Variables
	lazy var categoriesViewController: UIViewController = {
		return storyboard?.instantiateViewController(withIdentifier: "CategoriesTableViewController") as? CategoriesTableViewController ?? CategoriesTableViewController()
	}()
	
	lazy var cardsViewController: CardsViewController = {
		return storyboard?.instantiateViewController(withIdentifier: "CardsViewController") as? CardsViewController ?? CardsViewController()
	}()
	
	// MARK: - Instance Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadNeededChildViewController()
	}
	
	func loadNeededChildViewController() {
		let purchased = checkIfCardsPurchased()
		let rootViewController: UIViewController
		let hasRootViewController = childViewControllers.count > 0
		
		rootViewController = !purchased ? cardsViewController : categoriesViewController
		
		switch (purchased, hasRootViewController) {
		case (_, false):
			setRootViewController(to: rootViewController)
		case (true, true):
			guard let currentRootViewController = childViewControllers.first as? CardsViewController else {
				print("Cards View Controller not found")
				return
			}
			swap(current: currentRootViewController, with: rootViewController)
		default: break
		}
	}
	
	// MARK: - Helper Methods
	private func checkIfCardsPurchased() -> Bool {
		let userDefaults = UserDefaults.standard
		let purchased = userDefaults.bool(forKey: "PurchasedCards")
		return purchased
	}
	
	private func swap(current viewController: UIViewController, with newViewController: UIViewController) {
		addChildViewController(newViewController)
		viewController.willMove(toParentViewController: nil)
		
		transition(from: viewController, to: newViewController, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { [unowned self] in
			// Contraints
			newViewController.view.translatesAutoresizingMaskIntoConstraints = false
			self.view.constrainToView(newViewController.view)
		}) { _ in
			newViewController.didMove(toParentViewController: self)
			viewController.removeFromParentViewController()
		}
	}
	
	private func setRootViewController(to childViewController: UIViewController) {
		addChildViewController(childViewController)
		childViewController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(childViewController.view)
		view.constrainToView(childViewController.view)
		childViewController.didMove(toParentViewController: self)
	}
}
