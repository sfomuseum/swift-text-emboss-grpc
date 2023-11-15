# launchd

This is not a comprehensive guide to using `launchctl` which appears to a bit of a moving target and if the documentation is comprehensive it's not always obvious. https://www.launchd.info/ is a good place to start but even that has documentation that no longer seems to track with macOS 14 or higher.

Note that in these examples it is assumed you have set up a `sfomuseum` user account to run these services using the `dscl` tool. If you need some guidance on using the `dscl` tool this link is useful: https://serverfault.com/questions/182347/add-daemon-account-on-os-x

First copy the example plist file in to `/Library/Launch/Daemons/`.

```
$> sudo cp org.sfomuseum.textemboss.grpc.plist.org.sfomuseum.textemboss.grpc.plist /Library/Launch/Daemons/org.sfomuseum.textemboss.grpc.plist
```

Update the plist as necessary to reflect your environment; what host and port you want the service to run on, etc.

Now load the plist and start the corresponding service.

```
$> sudo launchctl -w load /Library/Launch/Daemons/org.sfomuseum.textemboss.grpc.plist

$> sudo launchctl start org.sfomuseum.textemboss.grpc
```

So far none of the documentation for "stopping" a service that I've read seem to work. The easiest way to stop a service is simply to remove it.

```
sudo launchctl remove /Library/Launch/Daemons/org.sfomuseum.textemboss.grpc.plist
```

Note that `launchctl` really doesn't like "-" in the name of a plist file you're asking it to load. It took me a while to figure that out.