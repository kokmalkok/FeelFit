//
//  FFTabBarController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

final class FFTabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBar(){
        setupControllerBar()
        
        tabBar.tintColor = FFResources.Colors.activeColor
        tabBar.barTintColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.masksToBounds = true
        let height = tabBar.frame.size.height/2
        tabBar.frame.size.height = height
        tabBar.frame.origin.y = tabBar.frame.size.height - height
        
        selectedIndex = getLastViewedViewControllerIndex()
        delegate = self
        
    }
    
    private func createTabBarItem(vc: UIViewController, title: String, image: String,tag: Int) -> UINavigationController {
        let image = UIImage(systemName: image)
        vc.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        let navigationController = FFNavigationController(rootViewController: vc)
        return navigationController
    }
    
    private func setupControllerBar(){
        let news = createTabBarItem(vc: FFNewsPageViewController(), title: "News", image: "newspaper",tag: FFTabBarIndex.news.rawValue)
        let exercises = createTabBarItem(vc: FFMusclesGroupViewController(), title: "Muscles", image: "figure.strengthtraining.traditional",tag: FFTabBarIndex.exercises.rawValue)
        let health = createTabBarItem(vc: FFPresentHealthCollectionView(), title: "Health", image: "heart.text.square",tag: FFTabBarIndex.health.rawValue)
        let plan = createTabBarItem(vc: FFTRainingPlanViewController(), title: "Plan", image: "checkmark.diamond",tag: FFTabBarIndex.trainingPlan.rawValue)
        let profile = createTabBarItem(vc: FFProfileViewController(), title: "My Profile", image: "person.fill",tag: FFTabBarIndex.user.rawValue)
        setViewControllers([news, exercises, plan, health, profile], animated: true)
    }
    
    private func getLastViewedViewControllerIndex() -> Int {
        if let index = UserDefaults.standard.object(forKey: "viewIndex") as? Int {
            return index
        }
        return 0
    }
}

extension FFTabBarController : UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        
        UserDefaults.standard.setValue(index, forKey: "viewIndex")
    }
}
