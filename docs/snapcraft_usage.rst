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
            source: https://github.com/diddledan/snapcraft-alsa.git
            plugin: nil
            override-pull: |
                cat > asound.conf <<EOF
                pcm.!default {
                    type pulse
                    fallback "sysdefault"
                    hint {
                        show on
                        description \"Default ALSA Output (currently PulseAudio Sound Server)\"
                    }
                }
                ctl.!default {
                    type pulse
                    fallback "sysdefault"
                }
                EOF
            override-build: "install -m644 -D -t $SNAPCRAFT_PART_INSTALL/etc asound.conf"
            build-packages:
            - libasound2-dev
            stage-packages:
            - libasound2
            - libasound2-plugins
            after:
            - alsa-lib-mixin
            - alsa-plugins-mixin

Now add this layout definition:

.. code-block:: yaml

    layout:
        "/etc/asound.conf":
            symlink: "$SNAP/etc/asound.conf"
        "/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib":
            symlink: "$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib"

Finally, add `after: [alsa-mixin]` to any parts that require ALSA.


See also
========

:ref:`Adding snapcraft-alsa to your snapcraft.yaml with jsonnet
<jsonnet_usage>`
