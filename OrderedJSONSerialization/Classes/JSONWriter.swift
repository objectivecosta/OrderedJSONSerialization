struct JSONWriter {
    var indent = 0
    let pretty: Bool
    let writer: (String?) -> Void

    init(pretty: Bool = true, writer: @escaping (String?) -> Void) {
        self.pretty = pretty
        self.writer = writer
    }
    
    mutating func serializeJSON(_ object: Any?) throws {

        let toSerialize = object
        
        guard let obj = toSerialize else {
            try self.serializeNull()
            return
        }
        
        // For better performance, the most expensive conditions to evaluate should be last.
        switch (obj) {
        case let str as String:
            try self.serializeString(str)
        case let boolValue as Bool:
            self.writer(boolValue.description)
        case let num as Int:
            self.writer(num.description)
        case let num as Int8:
            self.writer(num.description)
        case let num as Int16:
            self.writer(num.description)
        case let num as Int32:
            self.writer(num.description)
        case let num as Int64:
            self.writer(num.description)
        case let num as UInt:
            self.writer(num.description)
        case let num as UInt8:
            self.writer(num.description)
        case let num as UInt16:
            self.writer(num.description)
        case let num as UInt32:
            self.writer(num.description)
        case let num as UInt64:
            self.writer(num.description)
        case let dict as Array<(String, Any?)>:
            try self.serializeDictionary(dict)
        case let array as Array<Any?>:
            try self.serializeArray(array)
        case let num as Float:
            try self.serializeFloat(num)
        case let num as Double:
            try self.serializeFloat(num)
        case let num as Decimal:
            self.writer(num.description)
        case let num as NSDecimalNumber:
            self.writer(num.description)
        case is NSNull:
            try self.serializeNull()
        default:
            throw NSError(domain: NSCocoaErrorDomain, code: CocoaError.propertyListReadCorrupt.rawValue, userInfo: [NSDebugDescriptionErrorKey : "Invalid object cannot be serialized"])
        }
    }

    func serializeString(_ str: String) throws {
        self.writer("\"")
        for scalar in str.unicodeScalars {
            switch scalar {
                case "\"":
                    self.writer("\\\"") // U+0022 quotation mark
                case "\\":
                    self.writer("\\\\") // U+005C reverse solidus
                case "/":
                    self.writer("\\/") // U+002F solidus
                case "\u{8}":
                    self.writer("\\b") // U+0008 backspace
                case "\u{c}":
                    self.writer("\\f") // U+000C form feed
                case "\n":
                    self.writer("\\n") // U+000A line feed
                case "\r":
                    self.writer("\\r") // U+000D carriage return
                case "\t":
                    self.writer("\\t") // U+0009 tab
                case "\u{0}"..."\u{f}":
                    self.writer("\\u000\(String(scalar.value, radix: 16))") // U+0000 to U+000F
                case "\u{10}"..."\u{1f}":
                    self.writer("\\u00\(String(scalar.value, radix: 16))") // U+0010 to U+001F
                default:
                    self.writer(String(scalar))
            }
        }
        self.writer("\"")
    }

    private func serializeFloat<T: FloatingPoint & LosslessStringConvertible>(_ num: T) throws {
        guard num.isFinite else {
             throw NSError(domain: NSCocoaErrorDomain, code: CocoaError.propertyListReadCorrupt.rawValue, userInfo: [NSDebugDescriptionErrorKey : "Invalid number value (\(num)) in JSON write"])
        }
        var str = num.description
        if str.hasSuffix(".0") {
            str.removeLast(2)
        }
        self.writer(str)
    }

    mutating func serializeArray(_ array: [Any?]) throws {
        self.writer("[")
        if self.pretty {
            self.writer("\n")
            self.incAndWriteIndent()
        }
        
        var first = true
        for elem in array {
            if first {
                first = false
            } else if self.pretty {
                self.writer(",\n")
                self.writeIndent()
            } else {
                self.writer(",")
            }
            try self.serializeJSON(elem)
        }
        if self.pretty {
            self.writer("\n")
            self.decAndWriteIndent()
        }
        self.writer("]")
    }

    mutating func serializeDictionary(_ dict: Array<(String, Any?)>) throws {
        self.writer("{")
        if self.pretty {
            self.writer("\n")
            self.incAndWriteIndent()
        }

        var first = true

        func serializeDictionaryElement(key: AnyHashable, value: Any?) throws {
            if first {
                first = false
            } else if self.pretty {
                self.writer(",\n")
                self.writeIndent()
            } else {
                self.writer(",")
            }

            if let key = key as? String {
                try self.serializeString(key)
            } else {
                throw NSError(domain: NSCocoaErrorDomain, code: CocoaError.propertyListReadCorrupt.rawValue, userInfo: [NSDebugDescriptionErrorKey : "NSDictionary key must be NSString"])
            }
            self.pretty ? self.writer(" : ") : self.writer(":")
            try self.serializeJSON(value)
        }

        for (key, value) in dict {
            try serializeDictionaryElement(key: key, value: value)
        }

        if pretty {
            self.writer("\n")
            self.decAndWriteIndent()
        }
        self.writer("}")
    }

    func serializeNull() throws {
        self.writer("null")
    }
    
    let indentAmount = 2
    
    mutating func incAndWriteIndent() {
        self.indent += self.indentAmount
        self.writeIndent()
    }
    
    mutating func decAndWriteIndent() {
        self.indent -= self.indentAmount
        self.writeIndent()
    }
    
    func writeIndent() {
        for _ in 0..<self.indent {
            self.writer(" ")
        }
    }

}

