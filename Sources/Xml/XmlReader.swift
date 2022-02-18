//
//  KindKitXml
//

import Foundation
import KindKitCore

public struct XmlReader {
    
    public var document: XmlDocument
    
    public static func parse(data: Data) throws -> XmlDocument {
        let delegate = Delegate()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        if parser.parse() == true {
            return delegate.document
        } else {
            throw parser.parserError!
        }
    }
    
}

private extension XmlReader {
    
    class Delegate : NSObject, XMLParserDelegate {
        
        public var document: XmlDocument
        private var rootNodes: [XmlNode]
        private var recurseNodes: [XmlNode]
        private var trimmingCharacterSet: CharacterSet
        
        public override init() {
            self.document = XmlDocument()
            self.rootNodes = []
            self.recurseNodes = []
            self.trimmingCharacterSet = CharacterSet.whitespacesAndNewlines
            super.init()
        }
        
        public func parserDidEndDocument(_ parser: XMLParser) {
            self.document.nodes = self.rootNodes
        }
        
        public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            let attributes = attributeDict.compactMap({ (key, value) -> XmlAttribute in
                return XmlAttribute(name: key, value: XmlValue(text: value))
            })
            let node = XmlNode(name: elementName, attributes: attributes)
            if let parentNode = self.recurseNodes.last {
                parentNode.nodes.append(node)
            } else {
                self.rootNodes.append(node)
            }
            self.recurseNodes.append(node)
        }
        
        public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            guard let node = self.recurseNodes.last else {
                parser.abortParsing()
                return
            }
            if node.name != elementName {
                parser.abortParsing()
            }
            self.recurseNodes.removeLast()
        }
        
        public func parser(_ parser: XMLParser, foundCharacters string: String) {
            let trimString = string.trimmingCharacters(in: self.trimmingCharacterSet)
            if trimString.count > 0 {
                if let node = self.recurseNodes.last {
                    if let value = node.value {
                        node.value = XmlValue(text: value.text + trimString)
                    } else {
                        node.value = XmlValue(text: trimString)
                    }
                } else {
                    parser.abortParsing()
                }
            }
        }
        
    }
    
}
