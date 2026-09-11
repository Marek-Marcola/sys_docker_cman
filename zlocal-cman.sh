export PATH=/usr/local/bin/alias-cman:$PATH

cm() {
  local desc="@@container management (via cman.sh)@@"
  cman.sh $@
}

cdcm() {
  local desc="@@change working directory to cman $EDIR@@"
  local D="/usr/local/etc/cman.d"
  cd $D
  pwd
}
