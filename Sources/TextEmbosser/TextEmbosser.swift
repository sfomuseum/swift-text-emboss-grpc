import ArgumentParser

@main
struct RouteGuide: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "text-embosser",
    subcommands: [Serve.self],
    defaultSubcommand: Serve.self,
  )
}
