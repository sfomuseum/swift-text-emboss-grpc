// To do: Put this in a common sfomuseum/swift-logging package

import Foundation
import Logging
import Puppy

internal struct LogFormatter: LogFormattable {
    private let dateFormat = DateFormatter()

    init() {
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    }

    func formatMessage(_ level: LogLevel, message: String, tag: String, function: String,
                       file: String, line: UInt, swiftLogInfo: [String : String],
                       label: String, date: Date, threadID: UInt64) -> String {
        let date = dateFormatter(date, withFormatter: dateFormat)
        let fileName = fileName(file)
        let moduleName = moduleName(file)
        return "\(date) \(threadID) [\(level)] \(swiftLogInfo) \(moduleName)/\(fileName)#L.\(line) \(function) \(message)"
    }
}

public func NewLogger(log_label: String, log_file: String?, verbose: Bool) throws -> Logger  {
    
        let log_format = LogFormatter()
      
      // This does not work (yet) as advertised. Specifically only
      // the first handler added to puppy ever gets invoked. Dunno...
      // https://github.com/sushichop/Puppy/issues/89
    
      var puppy = Puppy()

      if log_file != nil {
          
          let log_url = URL(fileURLWithPath: log_file!).absoluteURL
          
          let rotationConfig = RotationConfig(suffixExtension: .numbering,
                                              maxFileSize: 30 * 1024 * 1024,
                                              maxArchivedFilesCount: 5)
          
          let fileRotation = try FileRotationLogger(log_label,
                                                    logFormat: log_format,
                                                    fileURL: log_url,
                                                    rotationConfig: rotationConfig
          )
          
          puppy.add(fileRotation)
      }
      
      // See notes above
      
      let console = ConsoleLogger(log_label, logFormat: log_format)
      puppy.add(console)
      
      LoggingSystem.bootstrap {
          
          var handler = PuppyLogHandler(label: $0, puppy: puppy)
          handler.logLevel = .info
          
          if verbose {
              handler.logLevel = .trace
          }
          
          return handler
      }
      
      let logger = Logger(label: log_label)
        return logger
    
}
