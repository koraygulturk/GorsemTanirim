import CoreData
import UIKit

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, NSXMLParserDelegate
{
    var data = NSMutableData()
    var categories:NSMutableArray = []
    var _version:Float = 0.0
    var _persons:NSMutableArray = []
    var jsonPath:String = "http://demo.afflications.com/people/kgulturk/data.json"
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    var inJsonString:Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        self.navigationController?.navigationBar.hidden = true
    
        let body = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\">" +
            "<soap:Body>" +
            "<GetPersonsJSON xmlns=\"http://tempuri.org/\" />" +
            "</soap:Body>" +
        "</soap:Envelope>"
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://admin.gorsemtanirim.com/services.asmx?op=GetPersonsJSON")!)
        request.HTTPMethod = "POST"
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        
        let op = AFHTTPRequestOperation(request: request)
        op.responseSerializer = AFXMLParserResponseSerializer() as AFHTTPResponseSerializer
        op.responseSerializer.acceptableContentTypes = NSSet(object: "application/soap+xml")

        op.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            var parser = responseObject as NSXMLParser
            parser.delegate = self
            parser.parse()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failure :\(error.localizedDescription)")
            })
        op.start()
        
        if Reachability.isConnectedToNetwork()
        {
            //startConnection()
        }
        else
        {
            println("internet is not available")
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func startConnection()
    {
        var url: NSURL = NSURL(string: jsonPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        self.data.appendData(data)
    }
        
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        let appDelegete:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDelegete.managedObjectContext!
        
        let ent =  NSEntityDescription.entityForName("Version", inManagedObjectContext: context) as NSEntityDescription!
        var version = Version(entity: ent, insertIntoManagedObjectContext: context);
        
        var versionOnDevice:Float = checkVersion()
         _version = jsonResult["version"] as Float
        
        println(versionOnDevice)
        println(_version)
        
        if (versionOnDevice == _version)
        {
            return
        }        
       
        version.setValue(_version, forKey: "version")
        context.save(nil);
        
        println(_version)
        
        getPeopleAndSaveCoreData(jsonResult)
    }
    
    func parser(parser: NSXMLParser!,didStartElement elementName: String!, namespaceURI: String!, qualifiedName : String!, attributes attributeDict: NSDictionary!)
    {
        if elementName == "GetPersonsJSONResult"
        {
            inJsonString = true
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if elementName == "GetPersonsJSONResult"
        {
            inJsonString = false
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        if inJsonString
        {
            println(string)
        }
    }
    
    func checkVersion() -> Float
    {
        var result = getVersionFetchRequest() as NSArray
        var versionId:Float = 1.0
        
        if result.count > 0
        {
            var res = result[0] as NSManagedObject
            versionId = res.valueForKey("version") as Float
        }
        
        return versionId
    }
    
    func getPeopleAndSaveCoreData(jsonResult:NSDictionary)
    {
        var persons:NSMutableArray = jsonResult["Persons"] as NSMutableArray
        
        let appDelegete:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDelegete.managedObjectContext!
        
        let ent =  NSEntityDescription.entityForName("Person", inManagedObjectContext: context) as NSEntityDescription!
        
        for personFromJson in persons
        {
            var person = Person(entity: ent, insertIntoManagedObjectContext: context);
            person.setValue(personFromJson["categoryId"], forKey: "categoryId")
            person.setValue(personFromJson["categoryName"], forKey: "categoryName")
            person.setValue(convertToBitmapData(personFromJson["image"] as String), forKey: "image")
            person.setValue(personFromJson["level"], forKey: "level")
            person.setValue(personFromJson["name"], forKey: "name")
        }
        
        context.save(nil)
    }
    
    func convertToBitmapData(imagePath:String) -> NSData
    {
        let url = NSURL(string:imagePath);
        
        let imageData = NSData(contentsOfURL: url!)
        let bgImage = UIImage(data:imageData!)
        
        return imageData!
    }
    
    func getVersionFetchRequest() -> NSArray
    {
        let appDelegete:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDelegete.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Version")
        request.returnsObjectsAsFaults = false;
        
        var result:NSArray = context.executeFetchRequest(request, error: nil)!
        
        return result
    }
}