//
//  ApiRepo+Heroes.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 28/4/23.
//

import Foundation

extension ApiRepository {
    
    public struct HeroError: Error {
        public enum HeroErrors: String {
            case CantCreateUrlWithString = "Can't create url with string"
            case CantCreateUrl = "Can't create url"
        }
        
        let error: HeroErrors
    }
    
    static func GetHeroes(offset: Int = 0, limit: Int = 20, callback: @escaping ([Hero]) -> () ) throws
    {
        guard var urlComponents = BaseComponents else { throw HeroError(error: .CantCreateUrlWithString) }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "offset", value: String(offset)))
        urlComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        
        guard let url = urlComponents.url else { throw HeroError(error: .CantCreateUrl) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("d39e81e4c5b9c338766dcf605bfe6501", forHTTPHeaderField: "apikey")
        
        //searchedText = self.searchField.text ?? ""
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                guard let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data) else { return }
                
                DispatchQueue.main.async {
                    callback(heroesResponse.data.results)
                }
                
                
                /*
                     //print(heroesResponse)
                    //if(self.searchedText == "Search" || self.searchedText == "") {
                        self.heroesLoaded.insert(contentsOf: heroesResponse.data.results, at: 0)
                    //}
                    /*else {
                        self.heroesLoaded = []
                        for hero in heroesResponse.data.results {
                            if(hero.name.contains(self.searchedText)) {
                                self.heroesLoaded.insert(hero, at: 0)
                            }
                        }
                    }*/
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                 */
                
            
            }
        }
            
        task.resume()
    }
}
