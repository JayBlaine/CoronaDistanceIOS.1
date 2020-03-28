import UIKit

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