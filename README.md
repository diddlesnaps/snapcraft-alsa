ALSA part for snapcraft, which will compile ALSA and install a loader script which
redirects audio through pulseaudio without requiring the `alsa` plug to be connected 
manually or by store assertion.

In your snap's snapcraft.yaml add `after: [alsa]` to the part which will depend
upon alsa, and add `alsa-launch` to your app's command. Remove any references
to `libasound2` and `libasound2-dev` from build- and stage-packages:

Due to a restriction on remote parts, you need to partially define the `alsa`
and `alsa-plugins` parts to force the build order and dependencies. This is done
by adding a part definition for each in your `snapcraft.yaml` and only specify
an `after:` clause for each. The rest of the part definition can inherit from
the remote part mechanism.

```yaml
apps:
  my-app:
    command: desktop-launch alsa-launch $SNAP/usr/bin/my-app
    plugs: [...]

parts:
  # specify remote part build order
  alsa:
    after: [alsa-lib, alsa-plugins]
  alsa-lib:
    # configflags needed until LP#1766878 is fixed
    configflags:
    - --prefix=/usr
    - --sysconfdir=/etc
    - --libexec=/usr/lib
    - --libdir=/usr/lib
    - --localstatedir=/var
    - --with-configdir=/snap/$SNAPCRAFT_PROJECT_NAME/current/usr/share/alsa
    - --with-plugindir=/snap/$SNAPCRAFT_PROJECT_NAME/current/usr/lib/alsa-lib
    - --disable-alisp
    - --disable-aload
    - --disable-python
    - --disable-rawmidi
    - --disable-static
    - --disable-topology
    - --disable-ucm
    - --enable-symbolic-functions
  alsa-plugins:
    after: [alsa-lib]
    # configflags needed until LP#1766878 is fixed
    configflags:
    - --prefix=/usr
    - --sysconfdir=/etc
    - --libexec=/usr/lib
    - --libdir=/usr/lib
    - --localstatedir=/var
    - --disable-arcamav
    - --disable-avcodec
    - --disable-jack
    - --disable-mix
    - --disable-oss
    - --disable-usbstream
    - --with-plugindir=/snap/$SNAPCRAFT_PROJECT_NAME/current/usr/lib/alsa-lib
    - --disable-static
    - LDFLAGS=-L$SNAPCRAFT_STAGE/usr/lib

  # your part
  depends-on-alsa:
    after: [alsa, desktop-glib-only]
    plugin: nil
    source: ...
    ...
```
