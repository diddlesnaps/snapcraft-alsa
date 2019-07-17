# Adding snapcraft-alsa to your sc-jsonnet configuration

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
} + alsa.apply()
```

You can also supply a version number to build a specific version of alsa, which will download and compile the version of alsa you specify. It will also try to remove any references to `libasound2` and `libasound2-plugins` from previously defined parts:

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
} + alsa.apply("1.1.9")
```

Ideally you would choose a commit hash for the address or copy the
file locally. To use a commit hash, try the following address,
which is for the latest commit as of writing this document:

```jsonnet
local alsa = import 'https://raw.githubusercontent.com/diddlesnaps/snapcraft-alsa/76fdc22/alsa.libsonnet';
```
