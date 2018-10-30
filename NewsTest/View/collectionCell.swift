import UIKit

class collectionCell: UICollectionViewCell {

    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    let newsManager = NewsManager.instance
    let client = Client.instance
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configurate(id : Int) {
        if newsManager.arrayNews.isEmpty {
            return
        }
        
        name.text = newsManager.arrayNews[id].name
        source.text = String(newsManager.arrayNews[id].id)
        date.text = "- " + String(newsManager.arrayNews[id].price)
        
        if !newsManager.arrayNews[id].image.isEmpty {
            let url = newsManager.arrayNews[id].image
            let urlImage:URL = URL(string: url)!
            self.image.sd_setImage(with: urlImage)
        }
    }
}
