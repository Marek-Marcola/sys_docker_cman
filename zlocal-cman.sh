export PATH=/usr/local/bin/alias-cman:$PATH

cm() {
  local desc="@@container management (via cman.sh)@@"
  cman.sh $@
}
