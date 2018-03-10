//
//  TabbarViewController.swift
//  DAW
//
//  Created by SS043 on 23/12/16.
//  Copyright © 2016 SS043. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController,UINavigationControllerDelegate {
    
    var tabCurrentIndex = UIBarItem()
    var tabArray = NSArray()
    var tabItem = UITabBarItem()

    
//    let unselectedColor = UIColor(red: 108/255.0, green: 110/255.0, blue: 114/255.0, alpha: 1.0)
//    let selectedColor = UIColor.redColor()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appearance = UITabBarItem.appearance()
//        let attributes: [String: AnyObject] = [NSFontAttributeName:UIFont(name: "Arimo-Regular", size: 15)!]
//        appearance.setTitleTextAttributes(attributes, for: .normal)
//        UITabBar.appearance().tintColor = UIColor.white
//       UITabBar.appearance().barTintColor = UIColor(red: 46.0 / 255.0, green: 46.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
//        for item in self.tabBar.items! {
//            if let image = item.image {
//                item.image = image.withRenderingMode(.alwaysOriginal)
//            }
//        }
        //MARK: set background image
        
//        let numberOfItems = CGFloat((self.tabBar.items!.count))
//        let tabBarItemSize = CGSize(width: (self.tabBar.frame.width) / numberOfItems, height: (self.tabBar.frame.height))
//        self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor.white, size: tabBarItemSize).resizableImage(withCapInsets: .zero)
//        self.tabBar.frame.size.width = self.view.frame.width + 10
//        self.tabBar.frame.origin.x = -2
//        self.tabBar.layer.borderWidth = 0.50
//        self.tabBar.layer.borderColor = UIColor.clear.cgColor
//        self.tabBar.clipsToBounds = true
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       // tabBarController?.selectedIndex = 4
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
//        //MARK: set text color of items
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blue], for: .selected)
//
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.green], for: .normal)
//
//   //MARK: set text color of bg of tabbar
//    self.tabBar.barTintColor = UIColor.white
//
    UITabBar.appearance().tintColor = UIColor(red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
//
//       // tabBarController?.selectedIndex = 2
    }
    }

//extension UIImage
// {
//    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage
//    {
//        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        color.setFill()
//        UIRectFill(rect)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return image
//    }
//}

