protoc:
	protoc Sources/Protos/text_embosser/text_embosser.proto \
		--proto_path=Sources/Protos/ \
		--plugin=/opt/homebrew/bin/protoc-gen-swift \
		--swift_opt=Visibility=Public \
		--swift_out=Sources/TextEmbosser/ \
		--plugin=/opt/homebrew/bin/protoc-gen-grpc-swift \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=Sources/TextEmbosser/

debug:
	./.build/debug/text-emboss-grpc-server \
		--logfile true

debug-tls:
	./.build/debug/text-emboss-grpc-server \
		--logfile true \
		--tls_certificate ./tls/server.crt \
		--tls_key ./tls/server.key

cert:
	openssl genrsa -out tls/server.key 4096
	openssl req -new -key tls/server.key -out tls/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=server"
	openssl x509 -key tls/server.key -in tls/server.csr -out tls/server.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=server" -req
