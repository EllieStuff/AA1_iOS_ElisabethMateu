//
//  MarvelRepository.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import Foundation

class MarvelRepository {
    static func GetApiData(urlComponent: MarvelURLComponents, onSuccess: @escaping ([Hero]) -> (), onError: @escaping (HeroeError)->() = {_ in } ) {
        guard let url = urlComponent.Components.url else {
            onError(HeroeError(error: .CantCreateUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    onError(HeroeError(error: .Unknown))
                }
                return
            }
            
            if let data = data {
                
                guard let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        onError(HeroeError(error: .CantParseData))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    onSuccess(heroesResponse.data.results)
                }
            
            }
        }
            
        task.resume()
    }
    
    public class MarvelURLComponents {
        
        public static let privateKey = "4f3428829d1aa6ed4953af97d38f360b9891c464"
        public static let publicKey = "d39e81e4c5b9c338766dcf605bfe6501"
        
        private var components: URLComponents?
        var Components: URLComponents { get { return components! } }
        
        enum SubPath: String {
            case Characters = "characters"
            case Comics = "comics"
        }
        
        init() {
            self.components = URLComponents(string: "https://gateway.marvel.com:443/v1/public/")
            
            let ts = String(Date().timeIntervalSince1970)
            let hash = Api.MD5(string: "\(ts)\(MarvelURLComponents.privateKey)\(MarvelURLComponents.publicKey)")
            
            components?.queryItems = [
                URLQueryItem(name: "apikey", value: MarvelURLComponents.publicKey),
                URLQueryItem(name: "ts", value: ts),
                URLQueryItem(name: "hash", value: hash)
            ]
        }
        
        
        @discardableResult func AddToPath(_ subPath: SubPath) -> MarvelURLComponents {
            self.components?.path += subPath.rawValue
            return self
        }
        
        /*@discardableResult static func +=(comp: MarvelURLComponents, subPath: SubPath) {
            comp.AddToPath(subPath)
        }*/
        
        @discardableResult func AddLimit(limit: Int) -> MarvelURLComponents  {
            self.components?.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
            return self
        }
        
        @discardableResult func AddOffset(offset: Int) -> MarvelURLComponents  {
            self.components?.queryItems?.append(URLQueryItem(name: "offset", value: String(offset)))
            return self
        }
        
        @discardableResult func AddFilter(filter: String) -> MarvelURLComponents  {
            self.components?.queryItems?.append(URLQueryItem(name: "nameStartsWith", value: filter))
            return self
        }
        
        @discardableResult func AddComicCharacter(character: String) -> MarvelURLComponents  {
            self.components?.queryItems?.append(URLQueryItem(name: "characters", value: character))
            return self
        }
        
    }

}


