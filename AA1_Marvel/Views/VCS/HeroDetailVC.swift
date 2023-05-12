//
//  HeroDetailVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 28/4/23.
//

import Foundation
import UIKit

class HeroDetailVC: UIViewController {
    
    public static var CurrHero: Hero?
    
    @IBOutlet weak var heroeName: UILabel!
    @IBOutlet weak var heroeImage: MyImageView!
    @IBOutlet weak var heroeDescription: UITextView!
    
    var pager: PagerContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heroeName.text = HeroDetailVC.CurrHero?.name
        heroeDescription.text = HeroDetailVC.CurrHero?.description
        if(heroeDescription.text == "") {
            heroeDescription.text = "No description available."
        }
        if let imageUrl = HeroDetailVC.CurrHero?.thumbnail?.Url {
            heroeImage.SetImageAsync(url: imageUrl)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //debugPrint(segue.identifier)
        if let pager = segue.destination as? PagerContainer {
            self.pager = pager
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func setComicsView(_ sender: Any) {
        self.pager?.SetComicsVC()
    }
    
    @IBAction func setSeriesView(_ sender: Any) {
        self.pager?.SetSeriesVC()
    }
    
    @IBAction func setStoriesView(_ sender: Any) {
        self.pager?.SetStoriesVC()
    }
    
    
}
