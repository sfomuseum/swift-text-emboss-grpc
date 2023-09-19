protoc:
	protoc Sources/TextEmbossGRPC/embosser.proto \
		--proto_path=Sources/TextEmbossGRPC/ \
		--plugin=/opt/homebrew/bin/protoc-gen-swift \
		--swift_opt=Visibility=Public \
		--swift_out=Sources/TextEmbossGRPC/ \
		--plugin=/opt/homebrew/bin/protoc-gen-grpc-swift \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=Sources/TextEmbossGRPC/

server:
	./.build/debug/text-emboss-grpc-server
