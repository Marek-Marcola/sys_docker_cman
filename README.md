docker cman
===========

Container management tools.

Deployment models: docker, podman, systemd, pacemaker

Install
-------
Install:

    cman.sh -inst -x
    -- or --
    cman.sh -anpb -x
    -- or --
    cp -fv cman.sh /usr/local/bin/cman.sh
    cp -fv cman.sh /usr/local/bin/cman-exec.sh
    cp -fv zlocal-cman.sh /etc/profile.d

    mkdir -pv /usr/local/etc/cman.d
    mkdir -pv /usr/local/bin/alias-cman

Verify:

    cm -ver

Help:

    cm -h
