//
//  PageContainerTest.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import Foundation
import UIKit

class PagerContainer : UIPageViewController {
    
    var vcs: [HeroesContentVC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let firstVC = storyboard.instantiateViewController(identifier: "Comics") as HeroesContentVC
        vcs.append(firstVC)
        vcs[0].contentType = .Comics
        vcs.append(storyboard.instantiateViewController(identifier: "Series") as HeroesContentVC)
        vcs[1].contentType = .Series
        vcs.append(storyboard.instantiateViewController(identifier: "Stories") as HeroesContentVC)
        vcs[2].contentType = .Stories
        
        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([firstVC], direction: .forward, animated: true)
    }
    
}


extension PagerContainer: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? HeroesContentVC else { return nil }
        
        guard let idx = vcs.firstIndex(of: vc) else {
            return nil
        }
        
        if(idx == 0) { return nil }
        
        var prev = (idx - 1) % vcs.count
        if(prev < 0) { prev = vcs.count - 1 }
        
        return vcs[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? HeroesContentVC else { return nil }
        
        guard let idx = vcs.firstIndex(of: vc) else {
            return nil
        }
        
        if(idx == (vcs.count - 1)) { return nil }
        
        let nxt = abs((idx + 1) % vcs.count)
        return vcs[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return vcs.count
    }
    
    
    func SetComicsVC()
    {
        self.setViewControllers([vcs[0]], direction: .forward, animated: true)
        //var comicsView:HeroComicsVC? = vcs[0] as? HeroComicsVC
        //comicsView?.HeroComicsVC()
    }
        
    func SetSeriesVC()
    {
        self.setViewControllers([vcs[1]], direction: .forward, animated: true)
    }
    
    func SetStoriesVC()
    {
        self.setViewControllers([vcs[2]], direction: .forward, animated: true)
    }
    
}
