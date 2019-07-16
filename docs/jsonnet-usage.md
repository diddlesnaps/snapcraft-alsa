# Adding snapcraft-alsa to your snapcraft-jsonnet configuration

I have been working on improving the sharing of snippets of
snapcraft.yaml code with a tool I found called
[jsonnet](https://jsonnet.org/). You can find
[sc-jsonnet](https://snapcraft.io/sc-jsonnet) in the snapstore,
which is a utility that I created using `libjsonnet`. It
enables you to create your `snapcraft.yaml` file with re-use
of shared code as a primary feature.

To add snapcraft-alsa to your `snapcraft.jsonnet` file, simply
add the import at the top of your jsonnet file and then append
the `alsa` object to your existing project definition:

```jsonnet
local snapcraft = import 'snapcraft.libsonnet';
local alsa = import 'https://raw.githubusercontent.com/diddlesnaps/snapcraft-alsa/master/alsa.libsonnet';

snapcraft {
    name: "my-super-snap",
    version: "0.1",
    parts: {
        mypart: {
            plugin: "nil",
        },
    },
} + alsa
```

Ideally you would choose a commit hash for the address or copy the
file locally. To use a commit hash, try the following address,
which is for the latest commit as of writing this document:

```jsonnet
local alsa = import 'https://raw.githubusercontent.com/diddlesnaps/snapcraft-alsa/9e505b1/alsa.libsonnet';
```
