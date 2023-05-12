//
//  MarvelRepository.swift
//  AA1_Marvel
//
//  Created by elisabeth.mateu@enti.cat on 5/5/23.
//

import Foundation

class MarvelRepository {
    /*static func GetApiData<T: Decodable>(urlComponent: MarvelURLComponents, onSuccess: @escaping (T) -> (), onError: @escaping (HeroError)->() = {_ in } ) {
        guard let url = urlComponent.Components.url else {
            onError(HeroError(error: .CantCreateUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    onError(HeroError(error: .Unknown))
                }
                return
            }
            
            if let data = data , let jsonStr = String(data:data, encoding: .utf8){
                debugPrint("Heroes Response:")
                //debugPrint(jsonStr)
                
                var jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                debugPrint(jsonDict)
                
                guard let heroesResponse = try? JSONDecoder().decode(HeroesResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        onError(HeroError(error: .CantParseData))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    //debugPrint("Heroes Response:")
                    //debugPrint(heroesResponse.data.results)
                    onSuccess(heroesResponse.data)
                }
            
            }
        }
            
        task.resume()
    }*/
    
    public class MarvelURLComponents {
        
        public static let privateKey = "4f3428829d1aa6ed4953af97d38f360b9891c464"
        public static let publicKey = "d39e81e4c5b9c338766dcf605bfe6501"
        
        private var components: URLComponents?
        var Components: URLComponents { get { return components! } }
        
        enum SubPath: String {
            case Characters = "characters"
            case Comics = "comics"
            case Series = "series"
            case Stories = "stories"
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
        
        @discardableResult func AddCharacterId(characterId: Int) -> MarvelURLComponents  {
            self.components?.queryItems?.append(URLQueryItem(name: "characters", value: String(characterId)))
            return self
        }
        
        
    }
    
    struct HeroesContentResponse: Codable {
        let code: Int
        let status: String
        let data: HeroesContentData
    }

    struct HeroesContentData: Codable {
        let results: [HeroesContent]
        let total: Int
    }

    struct HeroesContent: Codable {
        let id: Int
        let title: String
        let description: String?
        let thumbnail: Thumbnail?
    }
    
    struct Thumbnail : Codable {
        let path: String
        let `extension`: String
        
        var ImageUrl: String { get { return "\(path).\(`extension`)" } }
        var Url: URL? { get { return URL(string: ImageUrl) } }
    }

}


