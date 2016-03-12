//
//  ViewController.swift
//  Fun&Learn
//
//  Created by DuanErlong on 2015/09/24.
//  Copyright © 2015年 DuanErlong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,NSXMLParserDelegate{
    
    var surveyList = [Dictionary<String,String>]()
    var _surveyData :Dictionary<String,String>?
    @IBOutlet weak var tableView: UITableView!
    var XMLparser : NSXMLParser?
    
    // key and valuer element
    var _elementName : String?
    var _key : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.XMLparser?.delegate = self
        let path = NSBundle.mainBundle().pathForResource("data", ofType:"xml")
        let XMLparser : NSXMLParser? = NSXMLParser(data: NSData(contentsOfFile: path!)!)
        if XMLparser != nil {
            XMLparser!.delegate = self
            dispatch_async(dispatch_get_main_queue(), {     
                XMLparser!.parse()
            })
        } else {
            print("failed to parse XML")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveyList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.surveyList[indexPath.row]["title"]
        return cell
    }
    
    
    func parserDidStartDocument(parser: NSXMLParser) {
        print("parse start!")
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.tableView.reloadData()
        print("parse end!")
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        _elementName = elementName
        if elementName == "dict"{
            _surveyData = Dictionary<String,String>()
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "dict"{
            surveyList.append(_surveyData!)
        }
        _elementName = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print(string)
        if _elementName == "key"{
            _key = string
        }else if _elementName == "string"{
            _surveyData![_key!] = string
        }
    }

}

