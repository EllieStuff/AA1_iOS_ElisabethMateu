//
//  HeroStoriesVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 11/5/23.
//

import UIKit

class HeroStoriesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var GetStoriesInProgress: Bool = false
    var storiesLoaded: [MarvelRepository.HeroesContent] = []
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        
        GetMoreStories()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storiesLoaded.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath) as? DataCell else
        {
            return UICollectionViewCell()
        }
        
        
        cell.title.text = storiesLoaded[indexPath.row].title
        if let imageUrl = self.storiesLoaded[indexPath.row].thumbnail?.Url {
            cell.mImage.SetImageAsync(url: imageUrl)
        }
        
        if(indexPath.row + 5 >= storiesLoaded.count)
        {
            GetMoreStories()
        }
        
        
        return cell
    }

}


extension HeroStoriesVC {
    func GetMoreStories() {
        if(!GetStoriesInProgress)
        {
            GetStoriesInProgress = true;
            
            Api.Marvel.GetStories(offset: 3, limit: 30, characterId: HeroDetailVC.CurrHero?.id ?? 0) { stories in
                debugPrint(stories)
                self.GetStoriesInProgress = false
                self.storiesLoaded.insert(contentsOf: stories.results, at: self.storiesLoaded.count)
                self.collection.reloadData()
            } onError: { error in
                self.GetStoriesInProgress = false;
                debugPrint(error.error.rawValue)
            }
            
        }
    }
}
