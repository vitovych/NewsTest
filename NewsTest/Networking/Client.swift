import Foundation
import Alamofire

protocol TableViewDelegate {
    func reloadTableView()
}


class Client {
    static let instance = Client()
    
    var tableDelegate: TableViewDelegate?
    var countNews = 0
    
    var url = "http://allcom.lampawork.com/api/v1.0/products/"
    var newsManager = NewsManager.instance
    private init() {}
    
    
    func getDataFromServer() {
        request(self.url).responseJSON { responseJSON in
    
        switch responseJSON.result {
            case .success(let value):
                if let jsonObj = try? JSONSerialization.jsonObject(with: responseJSON.data!, options: .allowFragments) as? NSDictionary{
                    self.url = (jsonObj!.value(forKey: "next") as? String)!
                    if let results = jsonObj!.value(forKey: "results") as? NSArray {
                        self.countNews += results.count
                        for result in results{
                           if let result = result as? NSDictionary {
                                self.newsManager.arrayNews.append(News.init(json: result)!)
                           }
                        }
                        self.tableDelegate?.reloadTableView()
                    }
                }
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshURL(){
        self.countNews = 0
        self.newsManager.arrayNews.removeAll()
        self.url = "http://allcom.lampawork.com/api/v1.0/products/"
    }
    
}


