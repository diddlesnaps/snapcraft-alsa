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
``snapcraft.yaml``:

.. literalinclude:: ../snapcraft.yaml
  :start-after: ### START parts
  :end-before: ### END parts
  :language: yaml

Next add a ``layout`` definition so that the ALSA library can find the
pulseaudio plugin, along with any other plugins it might desire to load:

.. literalinclude:: ../snapcraft.yaml
  :start-after: ### START layout
  :end-before: ### END layout
  :language: yaml

Now, add ``after: [alsa-mixin]`` to any parts that require ALSA:

.. code-block:: yaml

    parts:
      ... # other parts here

      my-app:
        after: [alsa-mixin]
        ... # rest of my-app part here

Finally, add ``snap/command-chain/alsa-launch`` to the command chain of any
apps that need to use the sound system and specify the ``alsa``,
``audio-playback`` plug, and the ``audio-record`` plug if recording is
required e.g.

.. literalinclude:: ../snapcraft.yaml
  :start-after: ### START apps
  :end-before: ### END apps
  :language: yaml

See also
========

:ref:`Adding snapcraft-alsa to your snapcraft.yaml with jsonnet
<jsonnet_usage>`
