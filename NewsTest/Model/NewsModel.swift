import Foundation
import UIKit

struct News {
    
    var id: Int
    var name: String
    var price: Int
    var image: String
    
    init?(json: NSDictionary) {
        
        guard
            let id = json["id"] as? Int,
            let title = json["name"] as? String,
            let price = json["price"] as? Int,
            let image = json["image"]  as? NSDictionary
        else {
                return nil
        }
        
        self.id = id
        self.name = title
        self.price = price
        
        guard let url = image["url"] else {
           self.image = ""
           return
        }
        
        self.image = url as! String

    }
}

class NewsManager {
    static let instance = NewsManager()
    private init() {}
    
    var arrayNews = [News]()
    var images = [Int:UIImage]()
    var searchNews = [News]()
}
