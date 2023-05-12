//
//  PageContainerTest.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import Foundation
import UIKit

class PagerContainer : UIPageViewController {
    enum VCS: Int {
        case ComicsId = 0
        case SeriesId = 1
        case StoriesId = 2
    }
    
    var vcs: [HeroesContentVC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let firstVC = storyboard.instantiateViewController(identifier: "Comics") as HeroesContentVC
        vcs.append(firstVC)
        vcs[VCS.ComicsId.rawValue].contentType = .Comics
        vcs.append(storyboard.instantiateViewController(identifier: "Series") as HeroesContentVC)
        vcs[VCS.SeriesId.rawValue].contentType = .Series
        vcs.append(storyboard.instantiateViewController(identifier: "Stories") as HeroesContentVC)
        vcs[VCS.StoriesId.rawValue].contentType = .Stories
        
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
        self.setViewControllers([vcs[VCS.ComicsId.rawValue]], direction: .forward, animated: true)
    }
        
    func SetSeriesVC()
    {
        self.setViewControllers([vcs[VCS.SeriesId.rawValue]], direction: .forward, animated: true)
    }
    
    func SetStoriesVC()
    {
        self.setViewControllers([vcs[VCS.StoriesId.rawValue]], direction: .forward, animated: true)
    }
    
}
