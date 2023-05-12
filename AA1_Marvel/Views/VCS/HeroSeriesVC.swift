//
//  HeroSeriesVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 11/5/23.
//

import UIKit

class HeroSeriesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var GetSeriesInProgress: Bool = false
    var seriesLoaded: [MarvelRepository.HeroesContent] = []
    var totalResults: Int = 0
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        
        GetMoreSeries()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seriesLoaded.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath) as? DataCell else
        {
            return UICollectionViewCell()
        }
        
        cell.title.text = seriesLoaded[indexPath.row].title
        if let imageUrl = self.seriesLoaded[indexPath.row].thumbnail?.Url {
            cell.mImage.SetImageAsync(url: imageUrl)
        }
        
        if(seriesLoaded.count < self.totalResults && indexPath.row + 5 >= seriesLoaded.count)
        {
            GetMoreSeries()
        }
        
        
        return cell
    }

}


extension HeroSeriesVC {
    func GetMoreSeries() {
        if(!GetSeriesInProgress)
        {
            GetSeriesInProgress = true;
            
            Api.Marvel.GetSeries(offset: 3, limit: 30, characterId: HeroDetailVC.CurrHero?.id ?? 0) { seriesData in
                debugPrint(seriesData.results)
                self.GetSeriesInProgress = false
                self.totalResults = seriesData.total
                self.seriesLoaded.insert(contentsOf: seriesData.results, at: self.seriesLoaded.count)
                self.collection.reloadData()
            } onError: { error in
                self.GetSeriesInProgress = false;
                debugPrint(error.error.rawValue)
            }
            
        }
    }
    
}
