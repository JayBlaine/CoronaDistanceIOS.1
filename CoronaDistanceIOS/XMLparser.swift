//Enter the class information here {
import Foundation

struct RSSItem 
	{
	var title: String
	var description: String
	var pubdate: String
	}
	
// download xml from a server, parse xml to foundation object
class FeedParser: NSObject, XMLParserDelegate
	{
	public var rssItems: [RSSItem]= []
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
	}
	public var parserCompletion Handler: (([RSSItem]) -> Void)?
	}
	
	func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void?
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
































