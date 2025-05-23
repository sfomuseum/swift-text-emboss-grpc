import ArgumentParser
import Foundation
import Logging
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf
import Synchronization

import TextEmboss
import CoreGraphics
import CoreGraphicsImage
import SFOMuseumLogger

struct Serve: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Starts a image embosser server.")
    
    @Option(help: "The host name to listen for new connections")
    var host: String = "127.0.0.1"
    
    @Option(help: "The port to listen on")
    var port: Int = 8080
    
    @Option(help: "Log events to system log files")
    var logfile: Bool = false
    
    @Option(help: "Enable verbose logging")
    var verbose: Bool = false
        
    @Option(help: "The TLS certificate chain to use for encrypted connections")
    var tls_certificate: String = ""
    
    @Option(help: "The TLS private key to use for encrypted connections")
    var tls_key: String = ""
    
    @Option(help: "Sets the maximum message size in bytes the server may receive. If 0 then the swift-grpc defaults will be used.")
    var max_receive_message_length = 0
    
    func run() async throws {
        
        let log_label = "org.sfomuseum.text-emboss-grpc-server"
        
        let logger_opts = SFOMuseumLoggerOptions(
            label: log_label,
            console: true,
            logfile: logfile,
            verbose: verbose
        )
        
        let logger = try NewSFOMuseumLogger(logger_opts)
               
        var transportSecurity = HTTP2ServerTransport.Posix.TransportSecurity.plaintext
        
        // https://github.com/grpc/grpc-swift/issues/2219

        if tls_certificate != "" && tls_key != ""  {
                        
            let certSource:  TLSConfig.CertificateSource   = .file(path: tls_certificate, format: .pem)
            let keySource:   TLSConfig.PrivateKeySource    = .file(path: tls_key, format: .pem)
            
            transportSecurity = HTTP2ServerTransport.Posix.TransportSecurity.tls(
                certificateChain: [ certSource ],
                privateKey: keySource,
            )
        }
                 
        let transport = HTTP2ServerTransport.Posix(
            address: .ipv4(host: self.host, port: self.port),
            transportSecurity: transportSecurity,
        )
        
        let service = TextEmbosserService(logger: logger)
        let server = GRPCCore.GRPCServer(transport: transport, services: [service])
                
        try await withThrowingDiscardingTaskGroup { group in
            // Why does this time out?
            // let address = try await transport.listeningAddress
            logger.info("listening for requests on \(self.host):\(self.port)")
            group.addTask { try await server.serve() }
        }
    }
}

struct TextEmbosserService: OrgSfomuseumTextEmbosser_TextEmbosser.SimpleServiceProtocol {
    
    var logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func  embossText(request: OrgSfomuseumTextEmbosser_EmbossTextRequest, context: GRPCCore.ServerContext) async throws -> OrgSfomuseumTextEmbosser_EmbossTextResponse {
        
        var metadata: Logger.Metadata
        metadata = [ "remote": "\(context.remotePeer)" ]
        
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                                        isDirectory: true)
        
        let temporaryFilename = ProcessInfo().globallyUniqueString
        
        let temporaryFileURL =
        temporaryDirectoryURL.appendingPathComponent(temporaryFilename)
        
        try request.body.write(to: temporaryFileURL,
                               options: .atomic)
        
        defer {
            do {
                try FileManager.default.removeItem(at: temporaryFileURL)
            } catch {
                self.logger.error(
                    "Failed to remove \(temporaryFileURL), \(error)",
                    metadata: metadata
                )
            }
        }
        
        var cg_im: CGImage
        
        let im_rsp = CoreGraphicsImage.LoadFromURL(url: temporaryFileURL)
        
        switch im_rsp {
        case .failure(let error):
            self.logger.error(
                "Failed to load image from \(temporaryFileURL), \(error)",
                metadata: metadata
            )
            throw(error)
        case .success(let im):
            cg_im = im
        }
        
        let te = TextEmboss()
        let rsp = te.ProcessImage(image: cg_im)
        
        switch rsp {
        case .failure(let error):
            self.logger.error(
                "Failed to process image from \(temporaryFileURL), \(error)",
                metadata: metadata
            )
            throw(error)
        case .success(let rsp):
            
            self.logger.info(
                "Processed text from image \(temporaryFileURL)",
                metadata: metadata
            )
            
            return OrgSfomuseumTextEmbosser_EmbossTextResponse.with{
                
                var pb_rsp = OrgSfomuseumTextEmbosser_EmbossTextResult()
                pb_rsp.text = rsp.text
                pb_rsp.source = rsp.source
                pb_rsp.created = rsp.created
                
                $0.filename = request.filename
                $0.result = pb_rsp
            }
            
        }
        
    }

}
