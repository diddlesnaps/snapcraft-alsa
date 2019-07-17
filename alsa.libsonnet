{
    apply(version=""):: {
        local filterParts(name, part) = (
            if version == "" then part
            else {
                "build-packages": std.filter(
                    function(package) (package != "libasound2-dev"),
                    part["build-packages"]
                ),
                "stage-packages": std.filter(
                    function(package) (
                        package != "libasound2" &&
                        package != "libasound2-plugins"
                    ),
                    part["stage-packages"],
                ),
            }
        ),
        parts: std.mapWithKey(filterParts, super.parts)
         + {
            "alsa-mixin"+: {
                source: "https://github.com/diddledan/snapcraft-alsa.git",
                plugin: "nil",
                "override-pull": "
cat > asound.conf <<EOF
pcm.!default {
    type pulse
    fallback \"sysdefault\"
    hint {
        show on
        description \"Default ALSA Output (currently PulseAudio Sound Server)\"
    }
}
ctl.!default {
    type pulse
    fallback \"sysdefault\"
}
EOF",
                "override-build": "install -m644 -D -t $SNAPCRAFT_PART_INSTALL/etc asound.conf",
                "build-packages"+: (
                    if version == "" then [
                        "libasound2-dev"
                    ]
                ),
                "stage-packages"+: (
                    if version == "" then [
                        "libasound2",
                        "libasound2-plugins",
                    ]
                ),
            } + (
                if version != "" then {
                    after: ["alsa-lib-mixin", "alsa-plugins-mixin"],
                }
            ),
        } + (
            if version != "" then {
                "alsa-lib-mixin": {
                    plugin: "autotools",
                    source: "https://www.alsa-project.org/files/pub/lib/alsa-lib-" + version + ".tar.bz2",
                    configflags: [
                        "--prefix=/usr"
                    ],
                },
                "alsa-plugins-mixin": {
                    after: ["alsa-lib-mixin"],
                    plugin: "autotools",
                    source: "https://www.alsa-project.org/files/pub/plugins/alsa-plugins-" + version + ".tar.bz2",
                    configflags: [
                        "--prefix=/usr"
                    ],
                    "build-packages": [
                        "libpulse-dev",
                    ],
                    "stage-packages": [
                        "libpulse0",
                    ],
                },
            }
        ),
        layout+: {
            "/etc/asound.conf": {
                symlink: "$SNAP/etc/asound.conf",
            },
        } + (
            if version != "" then {
                "/usr/lib/alsa-lib": {
                    symlink: "$SNAP/usr/lib/alsa-lib",
                },
            } else {
                "/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib": {
                    symlink: "$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib",
                },
            }
        ),
    }
}
