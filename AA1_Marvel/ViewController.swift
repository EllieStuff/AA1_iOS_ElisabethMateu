//
//  ViewController.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 20/4/23.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {
    
    let privateKey = "4f3428829d1aa6ed4953af97d38f360b9891c464"
    let publicKey = "d39e81e4c5b9c338766dcf605bfe6501"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("d39e81e4c5b9c338766dcf605bfe6501", forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error
            in if let data = data, let text = String(data: data, encoding: .utf8) {
                print(text)
                
                if let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data){
                    print(heroesResponse)
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
    
    
    struct HeroesResponse: Decodable {
        let code: Int
        let status: String
        let data: HeroesData
    }
    
    struct HeroesData: Decodable {
        let results: [Hero]
    }
    
    struct Hero: Decodable {
        let id: Int
        let name: String
        let description: String
    }

}

