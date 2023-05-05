//
//  HeroContentVC.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import UIKit

class HeroComicsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //var comicsLoaded:
    var GetComicsInProgress: Bool = false
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath) as? DataCell else
        {
            return UICollectionViewCell()
        }
        
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HeroDetailVC {
    func HeroComicsVC() {
        if(!GetComicsInProgress)
        {
            GetComicsInProgress = true;
            
            Api.Marvel.GetComics(offset: 3, limit: 30, heroName: CurrHero?.name ?? "") { heroes in
                debugPrint(heroes)
                /*self.GetComicsInProgress = false
                self.heroesLoaded.insert(contentsOf: heroes, at: self.heroesLoaded.count)
                self.table.reloadData()*/
            } onError: { error in
                self.GetComicsInProgress = false;
                debugPrint(error.error.rawValue)
            }
            
        }
    }
    
    
}

