docker cman
===========

Docker container management tools.

Deployment models: docker, podman, systemd, pacemaker

Install
-------
Install:

    ./cman.sh --install

    cp -fv cman.sh /usr/local/bin/cman.sh
    cp -fv cman.sh /usr/local/bin/cman-exec.sh

Verify:

    cman.sh --version

Help:

    cman.sh --help

Alias:

    # cat > /etc/profile.d/zlocal-cman.sh <<\EOF
    export PATH=/usr/local/bin/alias-cman:$PATH
    
    cm() {
      local desc="@@container management (via cman.sh)@@"
      cman.sh $@
    }
    EOF
