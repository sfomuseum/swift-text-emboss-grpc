x-protoc:
	protoc Sources/Protos/text_embosser/text_embosser.proto \
		--proto_path=Sources/Protos/ \
		--swift_opt=Visibility=Public \
		--swift_out=Sources/TextEmbosser/ \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=Sources/TextEmbosser/ \
		--plugin=protoc-gen-grpc-swift-2=/opt/homebrew/Cellar/protoc-gen-grpc-swift/2.4.1/bin/protoc-gen-grpc-swift-2 \

protoc:
	protoc Sources/Protos/text_embosser/text_embosser.proto \
		--proto_path=Sources/Protos/ \
		--swift_opt=Visibility=Public \
		--swift_out=Sources/TextEmbosser/ \
		--plugin=protoc-gen-grpc-swift-2=/opt/homebrew/bin/protoc-gen-grpc-swift-2 \
		--grpc-swift-2_opt=Visibility=Public \
		--grpc-swift-2_out=Sources/TextEmbosser/

debug:
	./.build/debug/text-emboss-grpc-server \
		--verbose true

debug-tls:
	./.build/debug/text-emboss-grpc-server \
		--verbose true \
		--tls_certificate ./tls/server.crt \
		--tls_key ./tls/server.key

cert:
	openssl genrsa -out tls/server.key 4096
	openssl req -new -key tls/server.key -out tls/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=server"
	openssl x509 -key tls/server.key -in tls/server.csr -out tls/server.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=server" -req
