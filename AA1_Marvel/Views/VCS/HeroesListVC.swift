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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell else
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
        
        if(indexPath.row + 5 >= heroesLoaded.count)
        {
            GetMoreHerores()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("Hero selected => \(heroesLoaded[indexPath.row].name)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let heroDetailVC = storyboard.instantiateViewController(withIdentifier: "HeroDetail") as? HeroDetailVC {
            heroDetailVC.CurrHero = heroesLoaded[indexPath.row]
            self.present(heroDetailVC, animated: true)
        }
    }
    
    
    @IBAction func inputBegin(_ sender: Any) {
        searchField.text = ""
    }
    
    @IBAction func inputEnd(_ sender: Any) {
        //heroesLoaded = []
        searchedText = self.searchField.text ?? ""
    }
    @IBAction func inputChange(_ sender: Any) {
        //heroesLoaded = []
        searchedText = self.searchField.text ?? ""
        //table.reloadData()
    }
    
    
}


extension HeroesListVC {
    func GetMoreHerores() {
        if(!GetHeroesInProgress)
        {
            GetHeroesInProgress = true;
            
            do {
                try ApiRepository.GetHeroes(offset: heroesLoaded.count, limit: 50) { heroes in
                    self.GetHeroesInProgress = false
                    self.heroesLoaded.insert(contentsOf: heroes, at: self.heroesLoaded.count)
                    self.table.reloadData()
                }
            } catch let error as ApiRepository.HeroError {
                debugPrint((error.error))
            }
            catch {
                debugPrint(error)
            }
        }
    }
    
}
