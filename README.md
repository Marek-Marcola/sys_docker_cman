docker cman
===========

Container management tools.

Deployment models: docker, podman, systemd, pacemaker

Install
-------
Install:

    ./cman.sh --install
    -- or --
    cp -fv cman.sh /usr/local/bin/cman.sh
    cp -fv cman.sh /usr/local/bin/cman-exec.sh

    mkdir -pv /usr/local/etc/cman.d
    mkdir -pv /usr/local/bin/alias-cman

Postinstall:

    # cat > /etc/profile.d/zlocal-cman.sh <<\EOF
    export PATH=/usr/local/bin/alias-cman:$PATH
    
    cm() {
      local desc="@@container management (via cman.sh)@@"
      cman.sh $@
    }
    EOF

Verify:

    cman.sh --version

Help:

    cman.sh --help
