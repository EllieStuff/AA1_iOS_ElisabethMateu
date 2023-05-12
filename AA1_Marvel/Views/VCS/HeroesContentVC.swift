//
//  HeroSeriesVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 11/5/23.
//

import UIKit

class HeroesContentVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    enum HeroesContentType: String {
        case Comics = "Comics"
        case Series = "Series"
        case Stories = "Stories"
    }
    
    var contentType: HeroesContentType = .Series
    
    var GetLoadingContentInProgress: Bool = false
    var contentLoaded: [MarvelRepository.HeroesContent] = []
    var totalResults: Int = 0
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        
        GetMoreHeroesContent()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentLoaded.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath) as? DataCell else
        {
            return UICollectionViewCell()
        }
        
        cell.title.text = contentLoaded[indexPath.row].title
        if let imageUrl = self.contentLoaded[indexPath.row].thumbnail?.Url {
            cell.mImage.SetImageAsync(url: imageUrl)
        }
        
        if(contentLoaded.count < self.totalResults && indexPath.row + 5 >= contentLoaded.count)
        {
            GetMoreHeroesContent()
        }
        
        
        return cell
    }

}


extension HeroesContentVC {
    func GetMoreHeroesContent() {
        if(!GetLoadingContentInProgress)
        {
            GetLoadingContentInProgress = true;
            
            switch(contentType) {
            case .Comics:
                Api.Marvel.GetComics(offset: 3, limit: 30, characterId: HeroDetailVC.CurrHero?.id ?? 0, onSuccess: OnSucces, onError: OnError)
            case .Series:
                Api.Marvel.GetSeries(offset: 3, limit: 30, characterId: HeroDetailVC.CurrHero?.id ?? 0, onSuccess: OnSucces, onError: OnError)
            case .Stories:
                Api.Marvel.GetStories(offset: 3, limit: 30, characterId: HeroDetailVC.CurrHero?.id ?? 0, onSuccess: OnSucces, onError: OnError)
            }
        }
    }
    
    func OnSucces(contentResponse: MarvelRepository.HeroesContentResponse) {
        self.GetLoadingContentInProgress = false
        self.totalResults = contentResponse.data.total
        self.contentLoaded.insert(contentsOf: contentResponse.data.results, at: self.contentLoaded.count)
        self.collection.reloadData()
    }
    
    func OnError(error: MarvelRepository.HeroError) {
        self.GetLoadingContentInProgress = false;
        debugPrint(error.error.rawValue)
    }
    
}
