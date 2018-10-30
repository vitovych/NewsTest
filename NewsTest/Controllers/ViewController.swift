import UIKit
import SideMenu
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var searchBarRightConst: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var news: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    let client = Client.instance
    let newsManager = NewsManager.instance
    let network: NetworkManager = NetworkManager.instance
    
    var isNeedReloadCollectionView = false
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.news.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 22)!,NSAttributedString.Key.foregroundColor:UIColor.white],for: .disabled)
        
        self.setTabBarSetting()
        
        self.client.tableDelegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
    
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.searchBar.delegate = self
        
        self.getDataForTableView()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200;
        
        self.tableView.register(UINib (nibName: "topTableViewCell", bundle: nil), forCellReuseIdentifier: "topCell")
        self.tableView.register(UINib (nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "tableCell")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func searchBtnClick(_ sender: UIBarButtonItem) {
        
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
    
        self.searchBarRightConst.constant = 0
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        client.refreshURL()
        self.getDataForTableView()
        refreshControl.endRefreshing()
    }
    
    func getDataForTableView() {
        if network.reachability.connection != .none {
            client.getDataFromServer()
        } else {
            var alert = UIAlertView(title: "No Internet Connection", message: "Please connect to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    func setTabBarSetting() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 15)!,NSAttributedString.Key.foregroundColor:UIColor.gray],for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!,NSAttributedString.Key.foregroundColor:UIColor.white],for: .selected)
        
        let tabCount = CGFloat((tabBar.items?.count)!)
        let tabItemWidth = tabBar.frame.size.width / tabCount
        
        UITabBar.appearance().selectionIndicatorImage = imageWithColor(color: .white, size: CGSize(width:tabItemWidth, height: tabBar.frame.height))
        self.tabBar.selectedItem = tabBar.items![0]
    }
    
    func imageWithColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        
        UIRectFill(CGRect(origin: CGPoint.init(x: 0, y: size.height - size.height / 9), size: CGSize(width: size.width, height: size.height / 10)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image!
    }
}

extension ViewController: UITableViewDelegate{
   
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var countSections = client.countNews
        if self.isSearch {
            countSections = newsManager.searchNews.count + 1
        }
        return countSections
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == (client.countNews - 1)
        {
            self.getDataForTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath) as? topTableViewCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell?.reloadCollection(isNeedReload: self.isNeedReloadCollectionView)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? tableViewCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell?.configurate(id: indexPath.section - 1, isSearch : self.isSearch)
            return cell!
        }
    }
}

extension ViewController : TableViewDelegate {
    func reloadTableView() {
        self.isNeedReloadCollectionView = true
        self.tableView.reloadData()
    }
    
}

extension ViewController : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.searchBar.text = ""
        self.searchBarRightConst.constant = 190
        self.isSearch = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            self.isSearch = false
            view.endEditing(true)
            self.tableView.reloadData()
        } else {
            self.isSearch = true
            let filteredData = newsManager.arrayNews.filter({$0.name.lowercased().contains(searchBar.text!.lowercased())})
            self.newsManager.searchNews = filteredData
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
    
}
