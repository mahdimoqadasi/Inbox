//
//  InboxVC.swift
//  Inbox
//
//  Created by Mahdi Moqadasi on 5/3/1401 AP.
//

import UIKit

class InboxVC: UIViewController {
    
    @IBOutlet weak var PublicButton: StatefulButton!
    @IBOutlet weak var savedButton: StatefulButton!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var pagesContainer: UIView!
    @IBOutlet weak var indicator: UIView!
    var pages = PagesController(transitionStyle:UIPageViewController.TransitionStyle.scroll,
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
        self.addChild(pages)
        pages.view.frame = CGRect(x: 0, y: 0, width: self.pagesContainer.frame.width, height: self.pagesContainer.frame.height)
        self.pagesContainer.addSubview(pages.view)
        pages.indexDidChange = tabIndexChanged
    }

    private func tabIndexChanged(_ newIndex: Int) {
        updateIndicator(newIndex)
    }
    
    @IBAction func clickOnTab(_ sender: UIButton) {
        pages.setControllerWithIndex(index: sender.tag, direction: sender.tag == 0 ? .reverse : .forward)
        updateIndicator(sender.tag)
    }
    
    var lastIndex = 1
    private func updateIndicator(_ newIndex: Int) {
        guard lastIndex != newIndex else { return }
        lastIndex = newIndex
        let width = UIScreen.main.bounds.width / 2
        let amount = newIndex == 0 ? -width : width
        
        UIView.animate(withDuration: 0.25) {
            self.indicator.transform = self.indicator.transform.translatedBy(x: CGFloat(amount), y: 0)
            if newIndex == 0 { self.savedButton.setStyle(.enabled); self.PublicButton.setStyle(.disabled)}
            else { self.savedButton.setStyle(.disabled); self.PublicButton.setStyle(.enabled) }
        }
    }
    
}
