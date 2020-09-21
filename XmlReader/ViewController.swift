//
//  ViewController.swift
//  XmlReader
//
//  Created by 丁燕军 on 2020/9/19.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()    
    
    let str = """
    <?xml version="1.0" encoding="utf-8"?>
    <animals>
        <cats>
            <cat breed="Siberian" color="lightgray">Tinna</cat>
            <cat breed="Domestic" color="darkgray">Rose</cat>
            <cat breed="Domestic" color="yellow">Caesar</cat>
            <cat></cat>
        </cats>
        <dogs>
            <dog breed="Bull Terrier" color="white">Villy</dog>
            <dog breed="Bull Terrier" color="white">Spot</dog>
            <dog breed="Golden Retriever" color="yellow">Betty</dog>
            <dog breed="Miniature Schnauzer" color="black">Kika</dog>
        </dogs>
    </animals>
    """

    let data = str.data(using: .utf8)!
    guard let dict = XmlReader.dictionaryForXMLData(data: data) else {
      return
    }
    print(dict)
  }


}

