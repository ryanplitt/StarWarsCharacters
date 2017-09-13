# StarWarsCharacters

StarWarsCharacters is a simple app that was a great oppurtunity to learn some new libraries that I've never used. 
I used several different `pods` in this application, including:
 - `CBStoreHouseRefreshControl`: A custom pull-to-refresh control
 - `Sync`: An easy way to sync CoreData with JSON. This makes it really easy to keep the CoreData up to date with the API
 - `DATASource`: A wrapper for NSFetchedResultsController that plays really nice with Sync
 - `Kingfisher`: A popular library for downloading and caching images from the web
 - `Hero`: An iOS transition library that makes it easy to create custom transitions

As I mentioned before, I implemented these as a way to learn something new, and effectively make a simple yet fun app. It was really a lot of fun to make! 

I've tried to make my app as expandable as possible. Using Sync and DATASource allows the JSON to change and the tableView to be automatically updated (with animation). Having the pull to refresh is an easy and user friendly way of fetching if any changes have been made. I've also allowed each character to have an `affiliation` enum to properly sort, filter, or do anything else that we may want to later implement. 

I'd love to recieve any feedback that you have to offer. Please let me know what I could have done differently/better or what areas I'm lacking on. I'm always willing to be critiqued. 