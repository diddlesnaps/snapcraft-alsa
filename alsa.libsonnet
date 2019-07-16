{
    parts+: {
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
            "build-packages"+: ["libasound2-dev"],
            "stage-packages"+: ["libasound2", "libasound2-plugins"],
        },
    },
    layout+: {
        "/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/webkit2gtk-4.0": {
            symlink: "$SNAP/gnome-platform/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/webkit2gtk-4.0",
        },
        "/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib": {
            symlink: "$SNAP/usr/lib/$SNAPCRAFT_ARCH_TRIPLET/alsa-lib",
        },
        "/etc/asound.conf": {
            symlink: "$SNAP/etc/asound.conf",
        },
    },
}
