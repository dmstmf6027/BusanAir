//
//  ViewController.swift
//  BusanAir
//
//  Created by D7703_08 on 2018. 10. 15..
//  Copyright © 2018년 pgm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    var items = [AirData]()
    var item = AirData()
    var myPm10 = ""
    var mySite = ""
    var myPm10Cai = ""
    var currentElement = ""
    var currentTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTable.delegate = self
        myTable.dataSource = self
        myParse()
        
        
    }
    
    @objc func myParse() {
        let skey = "cLHR7K%2BU8sG3j6B0ULITYNuZPyKB1PYG2USwW3dYmJ5bzi%2FCc3CTAPzYOlnenW%2BUBUlbjpFtnF%2F6JIiRe3Ygmw%3D%3D"
        
        let strURL = "http://opendata.busan.go.kr/openapi/service/IndoorAirQuality/getIndoorAirQualityByStation?ServiceKey=\(skey)&date_hour=2011082309"
        
        if URL(string: strURL) != nil {
            
            if let myParser = XMLParser(contentsOf: URL(string: strURL)!) {
                myParser.delegate = self
                
                if myParser.parse(){
                    print("파싱 성공")
                    print("PM10")
                    for i in 0..<items.count {
                        switch items[i].dPm10Cai {
                        case "1" : items[i].dPm10Cai = "좋음"
                        case "2" : items[i].dPm10Cai = "보통"
                        case "3" : items[i].dPm10Cai = "나쁨"
                        case "4" : items[i].dPm10Cai = "매우나쁨"
                        default : break
                        }
                        for i in 0..<items.count{
                            print("\(items[i].dSite) : \(items[i].dPm10)")
                        }
                        
                    }
                    
                    
                    
                } else {
                    print("파싱 실패")
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        let name = cell.viewWithTag(3) as! UILabel
        let color = cell.viewWithTag(2) as! UILabel
        let site = cell.viewWithTag(1) as! UILabel
        
        name.text = items[indexPath.row].dPm10
        color.text = items[indexPath.row].dPm10Cai
        site.text = items[indexPath.row].dSite
        
        return cell
    }
    
    // XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            switch currentElement {
            case "pm10" : myPm10 = data
            case "site" : mySite = data
            case "pm10Cai" : myPm10Cai = data
            default : break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = AirData()
            myItem.dPm10 = myPm10
            myItem.dPm10Cai = myPm10Cai
            myItem.dSite = mySite
            items.append(myItem)
        }
    }
}
