.. _snapcraft_usage:

===============
Adding manually
===============

You can add this alsa-lib configuration to your project manually.
This method is limited to the Ubuntu-distributed version of ALSA
only, because the changes required for compiling ALSA from source
are too extensive to detail succinctly here. Such complex changes
are the reason that :std:doc:`sc-jsonnet <sc-jsonnet:index>` was
created.


Howto
=====

To use Ubuntu's ALSA, copy the following part into your
`snapcraft.yaml`:

.. code-block:: yaml

    parts:
      alsa-mixin:
        plugin: nil
        source: https://github.com/diddlesnaps/snapcraft-alsa.git
        override-pull: |
          cat > asound.conf <<EOF
          pcm.!default {
              type pulse
              fallback "sysdefault"
              hint {
                  show on
                  description "Default ALSA Output (currently PulseAudio Sound Server)"
              }
          }
          ctl.!default {
              type pulse
              fallback "sysdefault"
          }
          EOF
          cat > alsa-launch <<EOF
          #!/bin/bash
          export ALSA_CONFIG_PATH="\$SNAP/etc/asound.conf"

          if [ -d "\$SNAP/usr/lib/alsa-lib" ]; then
              export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:\$SNAP/usr/lib/alsa-lib"
          elif [ -d "\$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib" ]; then
              export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:\$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib"
          fi
          export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:\$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/pulseaudio"

          # Make PulseAudio socket available inside the snap-specific \$XDG_RUNTIME_DIR
          if [ -n "\$XDG_RUNTIME_DIR" ]; then
              pulsenative="pulse/native"
              pulseaudio_sockpath="\$XDG_RUNTIME_DIR/../\$pulsenative"
              if [ -S "\$pulseaudio_sockpath" ]; then
                  export PULSE_SERVER="unix:\${pulseaudio_sockpath}"
              fi
          fi

          exec "\$@"
          EOF
          chmod +x alsa-launch
        override-build: |
          snapcraftctl build
          install -m644 -D -t $SNAPCRAFT_PART_INSTALL/etc asound.conf
          install -m755 -D -t $SNAPCRAFT_PART_INSTALL/snap/command-chain alsa-launch
        build-packages:
          - libasound2-dev
        stage-packages:
          - libasound2
          - libasound2-plugins

Finally, add `after: [alsa-mixin]` to any parts that require ALSA, and add
`snap/command-chain/alsa-launch` to the command chain of any apps that need
to use the sound system e.g.

.. code-block:: yaml

    parts:
      ... # other parts here

      my-app:
        after: [alsa-mixin]
        ... # rest of my-app part here

    apps:
      my-app:
        command-chain: ["snap/command-chain/alsa-launch"]
        command: bin/my-app


See also
========

:ref:`Adding snapcraft-alsa to your snapcraft.yaml with jsonnet
<jsonnet_usage>`
