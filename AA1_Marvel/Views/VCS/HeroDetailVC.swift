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
    //@IBOutlet weak var collection: UICollectionView!
    
    //var comicsLoaded:
    
    var GetComicsInProgress: Bool = false
    var GetSeriesInProgress: Bool = false
    var GetStoriesInProgress: Bool = false
    
    @IBOutlet weak var heroeName: UILabel!
    @IBOutlet weak var heroeImage: MyImageView!
    @IBOutlet weak var heroeDescription: UITextView!
    
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
        
        //collection.dataSource = self
        //collection.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint(segue.identifier)
        if let pager = segue.destination as? PagerContainer {
            let i = 1
        }
    }
    
}
