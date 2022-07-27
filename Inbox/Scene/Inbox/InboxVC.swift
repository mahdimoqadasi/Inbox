//
//  InboxVC.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

class InboxVC: UIViewController, BadgeUpdater {
    @IBOutlet weak var publicButton: TabButton!
    @IBOutlet weak var savedButton: TabButton!
    @IBOutlet weak var pagesContainer: UIView!
    @IBOutlet weak var indicator: UIView!
    var pagesController = PagesController(transitionStyle:UIPageViewController.TransitionStyle.scroll,
                                navigationOrientation:UIPageViewController.NavigationOrientation.horizontal,
                                options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func addPageController() {
        self.pagesController.badgeUpdater = self
        self.addChild(pagesController)
        pagesController.view.frame = CGRect(x: 0, y: 0, width: self.pagesContainer.frame.width, height: self.pagesContainer.frame.height)
        self.pagesContainer.addSubview(pagesController.view)
        pagesController.indexDidChange = tabIndexChanged
    }

    private func tabIndexChanged(_ newIndex: Int) {
        updateIndicator(newIndex)
    }
        
    @IBAction func tapSavedTab(_ sender: Any) {
        pagesController.setControllerWithIndex(index: 0, direction: .reverse)
        updateIndicator(0)
    }
    
    @IBAction func tapPublicTab(_ sender: Any) {
        pagesController.setControllerWithIndex(index: 1, direction: .forward)
        updateIndicator(1)
    }
    
    var lastIndex = 1
    private func updateIndicator(_ newIndex: Int) {
        guard lastIndex != newIndex else { return }
        lastIndex = newIndex
        let width = UIScreen.main.bounds.width / 2
        let amount = newIndex == 0 ? -width : width
        
        UIView.animate(withDuration: 0.25) {
            self.indicator.transform = self.indicator.transform.translatedBy(x: CGFloat(amount), y: 0)
            self.savedButton.titleEnabled = newIndex == 0
            self.publicButton.titleEnabled = !self.savedButton.titleEnabled
        }
    }
    
    func updateBadge(_ text: String) {
        publicButton.badgeText = text
    }
}

protocol BadgeUpdater {
    func updateBadge(_ text: String)
}
