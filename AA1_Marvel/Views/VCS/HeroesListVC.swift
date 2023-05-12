//
//  ViewController.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 20/4/23.
//

import UIKit

class HeroesListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var heroesLoaded: [Hero] = []
    var GetHeroesInProgress: Bool = false
    var searchedText: String = ""
    var totalHeroes: Int = 0
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        GetMoreHerores()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.heroesLoaded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeroeCell") as? HeroeCell else
        {
            return UITableViewCell()
        }
        
        //cell.title.text = "Movie: " + movies[indexPath.row]
        //cell.mImage.image = UIImage(named: movies[indexPath.row])
        //cell.bt.addTarget(self, action: #selector(":PrintHola"), for: .touchUpInside)
        
        
        cell.title.text = heroesLoaded[indexPath.row].name
            
        cell.mDescription.text = heroesLoaded[indexPath.row].description
        if(cell.mDescription.text == "") { cell.mDescription.text = "No description available." }
        if let imageUrl = self.heroesLoaded[indexPath.row].thumbnail?.Url {
            cell.mImage.SetImageAsync(url: imageUrl)
        }
        
        if(heroesLoaded.count < totalHeroes && indexPath.row + 5 >= heroesLoaded.count)
        {
            GetMoreHerores()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let heroDetailVC = storyboard.instantiateViewController(withIdentifier: "HeroDetail") as? HeroDetailVC {
            HeroDetailVC.CurrHero = heroesLoaded[indexPath.row]
            heroDetailVC.modalPresentationStyle = .overFullScreen
            
            self.present(heroDetailVC, animated: true)
        }
    }
    
    
    @IBAction func inputBegin(_ sender: Any) {
        if(searchField.text == "Search") { searchField.text = "" }
    }
    
    
    @IBAction func searchBttnTouchUp(_ sender: Any) {
        if(self.searchField.text == nil) { return }
        
        searchedText = self.searchField.text ?? ""
        heroesLoaded = []
        GetMoreHerores()
        table.reloadData()
    }
    
}


extension HeroesListVC {
    func GetMoreHerores() {
        if(!GetHeroesInProgress)
        {
            GetHeroesInProgress = true;
            
            /*Api.Marvel.GetHeroes(offset: heroesLoaded.count, limit: 30, filter: searchedText) { heroes in
                self.GetHeroesInProgress = false
                self.heroesLoaded.insert(contentsOf: heroes, at: self.heroesLoaded.count)
                self.table.reloadData()
            } onError: { error in
                self.GetHeroesInProgress = false;
                debugPrint(error.error.rawValue)
            }*/
            
            Api.Marvel.GetHeroes(offset: heroesLoaded.count, limit: 30, filter: searchedText, onSuccess: OnSucces, onError: OnError)
            
        }
    }
    
    func OnSucces(heroesData: HeroesData) {
        self.GetHeroesInProgress = false
        self.totalHeroes = heroesData.total
        self.heroesLoaded.insert(contentsOf: heroesData.results, at: self.heroesLoaded.count)
        if(heroesLoaded.count > 0) { self.table.reloadData() }
    }
    
    func OnError(error: MarvelRepository.HeroError) {
        self.GetHeroesInProgress = false;
        debugPrint(error.error.rawValue)
        
    }
    
}
