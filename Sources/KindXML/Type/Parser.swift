//
//  KindKit
//

import Foundation

final class Parser : NSObject, XMLParserDelegate {
    
    var nodes: [Document.Node]
    
    private var _recurseNodes: [Document.Node]
    private var _trimmingCharacterSet: CharacterSet
    
    override init() {
        self.nodes = []
        self._recurseNodes = []
        self._trimmingCharacterSet = CharacterSet.whitespacesAndNewlines
        super.init()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let node = Document.Node(
            name: elementName,
            attributes: attributeDict.map({ Document.Attribute(name: $0, value: Document.Value(text: $1)) })
        )
        if let parentNode = self._recurseNodes.last {
            parentNode.nodes.append(node)
        } else {
            self.nodes.append(node)
        }
        self._recurseNodes.append(node)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let node = self._recurseNodes.last else {
            parser.abortParsing()
            return
        }
        if node.name != elementName {
            parser.abortParsing()
        }
        self._recurseNodes.removeLast()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimString = string.trimmingCharacters(in: self._trimmingCharacterSet)
        if trimString.count > 0 {
            if let node = self._recurseNodes.last {
                if let value = node.value {
                    node.value = Document.Value(text: value.text + trimString)
                } else {
                    node.value = Document.Value(text: trimString)
                }
            } else {
                parser.abortParsing()
            }
        }
    }
    
}
