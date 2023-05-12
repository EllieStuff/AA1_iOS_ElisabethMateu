//
//  HeroContentVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import UIKit

class HeroComicsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var GetComicsInProgress: Bool = false
    var comicsLoaded: [MarvelRepository.HeroesContent] = []
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        
        GetMoreComics()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicsLoaded.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath) as? DataCell else
        {
            return UICollectionViewCell()
        }
        
        
        cell.title.text = comicsLoaded[indexPath.row].title
        if let imageUrl = self.comicsLoaded[indexPath.row].thumbnail?.Url {
            cell.mImage.SetImageAsync(url: imageUrl)
        }
        
        if(indexPath.row + 5 >= comicsLoaded.count)
        {
            GetMoreComics()
        }
        
        
        return cell
    }

}


extension HeroComicsVC {
    func GetMoreComics() {
        if(!GetComicsInProgress)
        {
            GetComicsInProgress = true;
            
            Api.Marvel.GetComics(offset: 3, limit: 30, characterId: HeroDetailVC.CurrHero?.id ?? 0) { comics in
                debugPrint(comics)
                self.GetComicsInProgress = false
                self.comicsLoaded.insert(contentsOf: comics.results, at: self.comicsLoaded.count)
                self.collection.reloadData()
            } onError: { error in
                self.GetComicsInProgress = false;
                debugPrint(error.error.rawValue)
            }
            
        }
    }
    
}

