//
//  XmlReader.swift
//  XmlReader
//
//  Created by 丁燕军 on 2020/9/19.
//

import Foundation

class XmlReader: NSObject {
  
  private var dictionaryStack = NSMutableArray()
  
  public static func dictionaryForXMLData(data: Data) -> NSDictionary? {
    let reader = XmlReader()
    let rootDictionary = reader.object(with: data)
    return rootDictionary
  }
  
  private func object(with data: Data) -> NSDictionary? {
    
    dictionaryStack.add(NSMutableDictionary())
    
    let parser = XMLParser(data: data)
    parser.delegate = self
    let success = parser.parse()
    
    if success, let result = dictionaryStack.firstObject as? NSDictionary {
      return result
    }
    return nil
  }
  
  
}

extension XmlReader: XMLParserDelegate {
  
  public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    
    let parentDict = dictionaryStack.lastObject as! NSMutableDictionary
    
    let childDict = NSMutableDictionary();
    childDict.addEntries(from: attributeDict)
    
    let existingValue = parentDict[elementName]
    if (existingValue != nil) {
      var array: NSMutableArray
      if let existingValue = existingValue as? NSMutableArray {
        array = existingValue
      } else {
        array = NSMutableArray()
        array.add(existingValue!)
        
        parentDict[elementName] = array
      }
      
      array.add(childDict)
    } else {
      parentDict[elementName] = childDict
    }
    
    dictionaryStack.add(childDict)
  }
  
  public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    dictionaryStack.removeLastObject()
  }
  
  public func parser(_ parser: XMLParser, foundCharacters string: String) {
    
    let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !string.isEmpty else {
      return
    }
    
    let dictInProgress = dictionaryStack.lastObject as! NSMutableDictionary
    
    if let textInprogress = dictInProgress["text"] as? String {
      dictInProgress["text"] = textInprogress + string
    } else {
      dictInProgress["text"] = string
    }
    
    
  }
  
  public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    print("\(#file)---\(#function)---\(parseError)")
  }
  
}
