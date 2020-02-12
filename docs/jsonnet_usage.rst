.. _jsonnet_usage:

=====================
Using with sc-jsonnet
=====================

I have been working on improving the sharing of snippets of
snapcraft.yaml code with a tool I found called `jsonnet
<https://jsonnet.org/>`_. **sc-jsonnet** is a utility that I have
created using ``libjsonnet``; you can `find sc-jsonnet in the
snapstore <https://snapcraft.io/sc-jsonnet>`_. It enables you to
create your ``snapcraft.yaml`` file with re-use of shared code as
a primary feature. Find more information about **sc-jsonnet** at
the :std:doc:`sc-jsonnet documentation site <sc-jsonnet:index>`.


Howto
=====

To add snapcraft-alsa to your ``snapcraft.jsonnet`` file, simply
add the import at the top of your jsonnet file and then run the
``alsa.apply()`` function against your existing project
definition::

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

You can also supply a version number to build a specific version of
alsa, which will download and compile the version of alsa that you
specify. It will also try to remove any references to ``libasound2``
and ``libasound2-plugins`` from previously defined parts::

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

Ideally you would choose a commit hash for the address or copy the
file locally. To use a commit hash, try the following address,
which is for the latest commit as of writing this document::

    local alsa = import 'https://raw.githubusercontent.com/diddlesnaps/snapcraft-alsa/bdfde06/alsa.libsonnet';


See also
========

:ref:`Adding snapcraft-alsa to your snapcraft.yaml manually
<snapcraft_usage>`
