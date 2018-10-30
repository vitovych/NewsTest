import UIKit
import SDWebImage

class tableViewCell: UITableViewCell {
    
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var sourceLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    
    let newsManager = NewsManager.instance
    let client = Client.instance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    func configurate(id : Int, isSearch : Bool) {
        
        var news = newsManager.arrayNews
        
        if isSearch {
            news = newsManager.searchNews
        }
        
        if news.isEmpty {
            return
        }
        
        
       descriptionLbl.text =  news[id].name
       sourceLbl.text = String(news[id].id)
       dataLbl.text = "- " + String(news[id].price)
       
       if !news[id].image.isEmpty {
            let url = news[id].image
        
            let urlImage:URL = URL(string: url)!
            self.newsImage.sd_setImage(with: urlImage)
            self.heightConstant.constant = 200
       } else {
           self.newsImage.image = nil
           self.heightConstant.constant = 0
       }
       
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
    }

}
