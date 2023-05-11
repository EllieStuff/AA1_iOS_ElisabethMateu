//
//  HeroesDetailPagerVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 11/5/23.
//

import UIKit

class HeroesDetailPagerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint(segue.identifier)
        if let pager = segue.destination as? PagerContainer {
            let i = 1
        }
    }
}
