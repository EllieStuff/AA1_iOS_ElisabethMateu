//
//  PageContainerTest.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import Foundation
import UIKit

class PagerContainerTest : UIPageViewController {
    
    var vcs: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let firstVC = storyboard.instantiateViewController(identifier: "Comics")
        vcs.append(firstVC)
        vcs.append(storyboard.instantiateViewController(identifier: "Series"))
        vcs.append(storyboard.instantiateViewController(identifier: "Stories"))
        
        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([firstVC], direction: .forward, animated: true)
    }
    
}


extension PagerContainerTest: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = vcs.firstIndex(of: viewController) else {
            return nil
        }
        
        if(idx == 0) { return nil }
        
        var prev = (idx - 1) % vcs.count
        if(prev < 0) { prev = vcs.count - 1 }
        
        return vcs[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = vcs.firstIndex(of: viewController) else {
            return nil
        }
        
        if(idx == (vcs.count - 1)) { return nil }
        
        let nxt = abs((idx + 1) % vcs.count)
        return vcs[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return vcs.count
    }
    
}
