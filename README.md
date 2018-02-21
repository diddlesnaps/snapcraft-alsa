ALSA part for snapcraft, which will compile ALSA and install a loader script which
redirects audio through pulseaudio without requiring the `alsa` plug to be connected 
manually or by store assertion.

In your snap's snapcraft.yaml add `after: [alsa]` to the part which will depend
upon alsa, and add `alsa-launch` to your app's command. Remove any references
to `libasound2` and `libasound2-dev` from build- and stage-packages:

```
    apps:
      my-app:
        command: desktop-launch alsa-launch $SNAP/usr/bin/my-app
        plugs: [...]

    parts:
      depends-on-alsa:
        after: [alsa, desktop-glib-only]
        plugin: nil
        source: ...
        ...
```
