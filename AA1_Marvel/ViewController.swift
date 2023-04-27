//
//  ViewController.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 20/4/23.
//

import UIKit
import CryptoKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let privateKey = "4f3428829d1aa6ed4953af97d38f360b9891c464"
    let publicKey = "d39e81e4c5b9c338766dcf605bfe6501"
    var heroesLoaded: [Hero] = []
    var finalUrl: String = ""
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        guard var urlComponents = URLComponents(string: "https://gateway.marvel.com:443/v1/public/characters")
        else { return }
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(string: "\(ts)\(privateKey)\(publicKey)")
        
        let timeString = String(NSDate().timeIntervalSinceNow.hashValue)
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "hash", value: hash)
        ]
        
        
        guard let url = urlComponents.url else { return }
        finalUrl = urlComponents.path
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("d39e81e4c5b9c338766dcf605bfe6501", forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error
            in if let data = data, let text = String(data: data, encoding: .utf8) {
                //print(text)
                
                if let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data){
                    //print(heroesResponse)
                    self.heroesLoaded.insert(contentsOf: heroesResponse.data.results, at: 0)
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
            }
        }
            
        task.resume()
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    
    
    struct HeroesResponse: Decodable, Encodable {
        let code: Int
        let status: String
        let data: HeroesData
    }
    
    struct HeroesData: Decodable, Encodable {
        let results: [Hero]
    }
    
    struct Hero: Decodable, Encodable {
        let id: Int
        let name: String
        let description: String
        let thumbnail: Thumbnail?
    }
    
    struct Thumbnail : Codable {
        let path: String
        let `extension`: String
        
        var ImageUrl: String { get { return "\(path).\(`extension`)" } }
        var Url: URL? { get { return URL(string: ImageUrl) } }
    }
    
    
    
    
}

