//
//  KindKit
//

extension Pattern {
    
    public final class Context {
        
        var result: [String : Pattern.Match] = [:]
        var recorder: Pattern.Recorder?
        
        var isEmpty: Bool {
            return self.result.isEmpty
        }

        init() {
        }
        
        public func scope(_ block: () throws -> Void) {
            let result = self.result
            do {
                try block()
            } catch {
                self.result = result
            }
        }
        
        public func scope(_ recorder: Pattern.Recorder, _ block: () throws -> Void) throws {
            let previuos = self.recorder
            self.recorder = recorder
            do {
                try block()
                self.result[recorder.key] = recorder.commit()
                self.recorder = previuos
            } catch let error {
                recorder.reset()
                self.recorder = previuos
                throw error
            }
        }
        
        public func append(_ part: Scanner.Result) throws {
            if let recorder = self.recorder {
                recorder.append(part)
            }
        }
        
    }
    
}
