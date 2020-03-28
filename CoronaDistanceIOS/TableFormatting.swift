import UIKit

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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	