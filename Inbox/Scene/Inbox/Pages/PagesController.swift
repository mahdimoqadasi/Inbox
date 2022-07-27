//
//  PagesController.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

class PagesController: UIPageViewController {
    
    let sb = UIStoryboard(name: "Inbox", bundle: nil)
    var currentIndex = 1
    var indexDidChange: ((Int) -> Void)? //should set for inform indicator
    var badgeUpdater: BadgeUpdater?
    
    var orderedVCs: [UIViewController] {
        let savedMsgs = sb.instantiateViewController(withIdentifier: "SavedMessagesVC")
        let publicMsgs = sb.instantiateViewController(withIdentifier: "PublicMessagesVC") as! PublicMessagesVC
        publicMsgs.badgeUpdater = badgeUpdater
        return [savedMsgs, publicMsgs]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllers([orderedVCs.last!], direction: .forward, animated: true, completion: nil)
    }
        
    func setControllerWithIndex(index: Int,direction: UIPageViewController.NavigationDirection ){
        setViewControllers([orderedVCs[index]], direction: direction, animated: true, completion: nil)
    }
    
    func changeViewController(currentIndex: Int, nextIndex: Int){
        switch nextIndex {
        case 0:
            if nextIndex>currentIndex{
                setControllerWithIndex(index:0,direction: .forward)
            }else{
                setControllerWithIndex(index :0,direction: .reverse)
            }
        case 1:
            if nextIndex>currentIndex{
                setControllerWithIndex(index :1,direction: .forward)
            }else{
                setControllerWithIndex(index :1,direction: .reverse)
            }
        default: break
        }
    }
}

extension PagesController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedVCs.map({$0.nibName}).firstIndex(of: viewController.nibName) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedVCs.count > previousIndex else { return nil }
        return orderedVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedVCs.map({$0.nibName}).firstIndex(of: viewController.nibName) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard orderedVCs.count != nextIndex else { return nil }
        guard orderedVCs.count > nextIndex else { return nil }
        return orderedVCs[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
               let index = orderedVCs.map({$0.nibName}).firstIndex(of: currentViewController.nibName) {
                currentIndex = index
                print(">>>new index: \(index)")
                indexDidChange?(index)
            }
        }
    }
}
