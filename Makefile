protoc:
	protoc Sources/text-emboss-grpc-server/embosser.proto \
		--proto_path=Sources/text-emboss-grpc-server/ \
		--plugin=/opt/homebrew/bin/protoc-gen-swift \
		--swift_opt=Visibility=Public \
		--swift_out=Sources/text-emboss-grpc-server/ \
		--plugin=/opt/homebrew/bin/protoc-gen-grpc-swift \
		--grpc-swift_opt=Visibility=Public \
		--grpc-swift_out=Sources/text-emboss-grpc-server/
