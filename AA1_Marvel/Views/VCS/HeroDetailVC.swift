//
//  HeroDetailVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 28/4/23.
//

import Foundation
import UIKit

class HeroDetailVC: UIViewController {
    
    public var CurrHero: Hero?
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
        
        heroeName.text = CurrHero?.name
        heroeDescription.text = CurrHero?.description
        if(heroeDescription.text == "") {
            heroeDescription.text = "No description available."
        }
        if let imageUrl = CurrHero?.thumbnail?.Url {
            heroeImage.SetImageAsync(url: imageUrl)
        }
        
        //collection.dataSource = self
        //collection.delegate = self
        
    }
    
    
}
