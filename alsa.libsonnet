function(version="") {
    local apps = (
        if "apps" in super then super.apps
        else {}
    ),
    local parts = (
        if "parts" in super then super.parts
        else {}
    ),

    layout+: (
        if version == "" then
            {
                "/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib": {
                    bind: "$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib"
                },
            }
        else
            {
                "/usr/lib/alsa-lib": {
                    bind: "$SNAP/usr/lib/alsa-lib"
                },
            }
    ) + {
        "/usr/share/alsa": {
            bind: "$SNAP/usr/share/alsa"
        },
    },

    apps: std.mapWithKey(function(name, app) (
        app + {
            "command-chain": std.setUnion((
                if std.objectHas(app, 'command-chain') then
                    app['command-chain']
                else []
            ), ['snap/command-chain/alsa-launch']),
            plugs: std.setUnion((
                if std.objectHas(app, 'plugs') then
                    app.plugs
                else []
            ), ["audio-playback", "audio-record"])
        }
    ), apps),

    parts: std.mapWithKey(function(name, part) (
        part + {
            "build-packages": (
                if std.objectHas(part, 'build-packages') then
                    std.filter(
                        function(package) (package != "libasound2-dev"),
                        part["build-packages"]
                    )
                else []
            ),
            "stage-packages": (
                if std.objectHas(part, 'stage-packages') then
                    std.filter(
                        function(package) (
                            package != "libasound2" &&
                            package != "libasound2-plugins"
                        ),
                        part["stage-packages"]
                    )
                else []
            ),
            stage: std.setUnion((
                if std.objectHas(part, 'stage') then
                    part.stage
                else []
            ), [
                "-usr/share/alsa",
                "-usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib",
                "-usr/lib/$SNAPCRAFT_ARCH_TRIPLET/libasound*"
            ]),
            after: std.setUnion((
                if std.objectHas(part, 'after') then
                    part.after
                else []
            ), ["alsa-mixin"]),
        }
    ), parts) + {
        "alsa-mixin": {
            plugin: "dump",
            source: "https://github.com/diddlesnaps/snapcraft-alsa.git",
            "source-subdir": "snapcraft-assets",
            "build-packages": (
                if version == "" then ["libasound2-dev"]
                else []
            ),
            "stage-packages": (
                if version == "" then ["libasound2", "libasound2-plugins"]
                else []
            ) + ["yad"],
            after: (
                if version == "" then []
                else ["alsa-lib-mixin", "alsa-plugins-mixin"]
            )
        },
    } + (
        if version == "" then {}
        else {
            "alsa-lib-mixin": {
                plugin: "autotools",
                source: "https://www.alsa-project.org/files/pub/lib/alsa-lib-" + version + ".tar.bz2",
                configflags: ["--prefix=/usr"],
            },
            "alsa-plugins-mixin": {
                after: ["alsa-lib-mixin"],
                plugin: "autotools",
                source: "https://www.alsa-project.org/files/pub/plugins/alsa-plugins-" + version + ".tar.bz2",
                configflags: ["--prefix=/usr"],
                "build-packages": ["libpulse-dev"],
                "stage-packages": ["libpulse0"],
            },
        }
    )
}
