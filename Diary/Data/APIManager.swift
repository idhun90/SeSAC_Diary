import Foundation

import Alamofire
import SwiftyJSON

class APIManager {

    static let shared = APIManager()
    
    private init() {}
    
    func fetchImage(query: String, page: Int, completionHandler: @escaping ([UnsplashData]) -> () ) {
        
        let url = "\(EndPoint.unsplashURL)?page=\(page)&per_page=30&query=\(query)&client_id=\(API.unsplashAccessKey)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)"
                
                let imageData = json["results"].arrayValue.map {
                    UnsplashData(regularImageUrl: $0["urls"]["regular"].stringValue)
                }
                print("==================\(imageData.count)====================") // 30이 나와야함
                completionHandler(imageData)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
