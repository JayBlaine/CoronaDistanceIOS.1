//Enter the class information here {
import Foundation
import UIKit

struct RSSItem
    {
    var title: String
    var description: String
    var pubdate: String
    }
    
// download xml from a server, parse xml to foundation object
class FeedParser: NSObject, XMLParserDelegate
    {
    public var rssItems: [RSSItem] = []
    public var currentKey = ""
    public var currentTitle: String = ""
    {
        didSet
        {
        currentTitle = currentTitle.trimmingCharacters(in: characterSet.whitespacesAndNewlines)
        }
    }
    public currentDescription: String = ""
    {
        didSet
        {
        currentDescription = currentDescription.trimmingCharacters(in: characterSet.whitespacesAndNewlines)
        }
    }
    public var currentPubDate: String = ""
        {
        didSet
        {
        currentPubDate = currentPubDate.trimmingCharacters(in: characterSet.whitespacesAndNewlines)
        }
 
    public var parserCompletion Handler: (([RSSItem]) -> Void)?
    }
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
        {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = urlSession.shared
        let task = urlSession,dataTask(with: request) { (data, response, error) in
            guard let data = data
            else
                {
                if let error = error
                    {
                    print(error.localizedDescription)
                    }
                    return
                }
                //this will parse the xml data
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
            task.resume()
        }
        
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributesDict: [String : String] = [ : ])
        {
        currentElement = elementName
        if currentElement == "item"
            {
            currentTitle = ""
            currentDescription = ""
            CurrentPubDate = ""
            }
        }
        
    func parser(_ parser: XMLParser, foundCharacters temp: String)
        {
        switch currentElement
            {
            case "title": currentTitle += temp
            
            case "description": currentDescription += temp
            
            case "pubdate": currentPubDate += temp
            default: break
            }
        }
        
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
        {
        if elementName == "item"
            {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            self.rssItems.append(rssItem)
            }
        }
        
    func parserDidEndDocument(_ parser: XMLParser)
        {
        parserCompletionHandler?(rssItems)
        }
        
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
        {
        print(parseError.localizedDescription)
        }

}

























class NewsTableViewController: UITableViewController
    {
    public var rssItems: [RSSItem]?
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchData()
        }
        
        public func fetchData()
            {
            
            for n in 1...4
                {
                switch counter
                    {
                    case 0:
                        let feedParser.parseFeed(url: "http://rss.cnn.com/rss/cnn_health.rss"){ (rssItems) in
                        self.rssItems = rssItems
                        
                        OperationQueue.main,addOperation
                            {
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
                            }
                        }
            
                    case 1:
                        let feedParser.parseFeed(url: "https://www.foxnews.com/about/rss"){ (rssItems) in
                        self.rssItems = rssItems
                        
                        OperationQueue.main,addOperation
                            {
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
                            }
                        }
                        
                    case 2:
                        let feedParser.parseFeed(url: "https://www.who.int/feeds/entity/csr/don/en/rss.xml"){ (rssItems) in
                        self.rssItems = rssItems
                        
                        OperationQueue.main,addOperation
                            {
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
                            }
                        }
            
                    case 3:
                        let feedParser.parseFeed(url: "https://tools.cdc.gov/api/v2/resources/media/403372.rss"){ (rssItems) in
                        self.rssItems = rssItems
                        
                        OperationQueue.main,addOperation
                            {
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
                            }
                        }
            
                    case 4:
                        let feedParser.parseFeed(url: "http://feeds.bbci.co.uk/news/health/rss.xml#"){ (rssItems) in
                        self.rssItems = rssItems
                        
                        OperationQueue.main,addOperation
                            {
                            self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
                            }
                        }
            
                    default: break
                    }
                }
            }
        
        override func numberOfSections(in tableView: UITableView) -> Int
            {
            return 1
            }
            
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
            {
            guard let rssItems = rssItems else {
                return 0
                }
                
            return rssItems.count
            }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
            
            if let item = rssItems?[indexPath.item]
                {
                cell.item = item
                }
                
            return cell
            }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    class NewsTableViewCell: UITableViewCell
        {
        @IBOutlet weak var titleLabel:UILabel!
        @IBOutlet weak var descriptionLabel:UILabel!
        @IBOutlet weak var dateLabel:UILabel!
        
        var item: RSSItem!
            {
            didSet
                {
                titleLabel.text = item.title
                descriptionLabel.text = item.Description
                dateLabel.text = item.pubDate
                }
            }
        }


