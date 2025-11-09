#!/bin/bash

VERSION_BIN="202511100061"

ID="[${0##*/}]"

INSTALL=0
VERSION=0
BACKUP=0
BACKUP_LIST=0
LINK=0
PULL=0
CHAIN=0
AINIT=0
RUN=0
EXEC=0
EVAL=0
CREATE=0
CREATE_UNIT=0
CREATE_PCMK=0
DELETE=0
DELETE_UNIT=0
DELETE_PCMK=0
RESTART=0
RESTART_UNIT=0
RESTART_PCMK=0
ULIST=0
USHOW=0
USTATUS=0
PLIST=0
PSHOW=0
PSTATUS=0
ELIST=0
ESHOW=0
ESHOW_ALL=0
EEDIT=0
EEDIT_TEMPLATE=0
ALIST=0
AHISTORY=0
AIMAGE=0
ANOTE=0
ATAGS=0
ALOG=0
HELP=0
QUIET=0

declare -a ARGS1
declare -a OPTS2
ARGS2=""
REXP=""

DDIR=/var/backup/cman

s=0

: ${A:=$(basename ${BASH_SOURCE%.sh})}
: ${APN:=$(echo $A|cut -d- -f2)}
: ${API:=$(echo $A|cut -d- -f3-)}
: ${EDIR:="/usr/local/etc/cman.d"}
: ${BDIR:="/usr/local/bin/alias-cman"}
: ${COMM:=$(readlink -f ${BASH_SOURCE})}

: ${RUN_FG:="-ti --rm"}
: ${RUN_BG:="-d --restart=always"}

if [ $# -eq 0 ]; then
  if [ "$A" = "cman" ]; then
    ELIST=1
    QUIET=1
  else
    AHISTORY=1
  fi
fi

if [[ $COMM == *cman-exec.sh ]]; then
  set - -- $*
  AHISTORY=0
  QUIET=1
fi

while [ $# -gt 0 ]
do
  case $1 in
    --inst*|-inst*)
      INSTALL=1
      shift
      ;;
    --vers*|-vers*)
      VERSION=1
      shift
      ;;
    -B)
      BACKUP=1
      BACKUP_LIST=1
      shift
      ;;
    -Bl)
      BACKUP_LIST=1
      shift
      ;;
    -A)
      A="$2"
      shift; shift
      ;;
    -V)
      V="$2"
      shift; shift
      ;;
    -I)
      I="$2"
      shift; shift
      ;;
    -Ed)
      EDIR="$2"
      shift; shift
      ;;
    -Bd)
      BDIR="$2"
      shift; shift
      ;;
    -L)
      LINK=1
      shift
      ;;
    -x)
      EVAL=1
      shift
      ;;
    -P)
      PULL=1
      shift
      ;;
    -ic)
      CHAIN=1
      shift
      ;;
    --init|-init)
      AINIT=1
      shift
      ;;
    -r)
      RUN=1
      shift
      ;;
    -e)
      EXEC=1
      QUIET=1
      shift
      ARGS2=$*
      break
      ;;
    -c)
      CREATE=1
      shift
      ;;
    -cu)
      CREATE_UNIT=1
      shift
      ;;
    -cp)
      CREATE_PCMK=1
      shift
      ;;
    -d)
      DELETE=1
      shift
      ;;
    -du)
      DELETE_UNIT=1
      shift
      ;;
    -dp)
      DELETE_PCMK=1
      shift
      ;;
    -R)
      RESTART=1
      shift
      ;;
    -Ru)
      RESTART_UNIT=1
      shift
      ;;
    -Rp)
      RESTART_PCMK=1
      shift
      ;;
    -ul)
      ULIST=1
      QUIET=1
      shift
      ;;
    -us)
      USHOW=1
      shift
      ;;
    -u)
      USTATUS=1
      shift
      ;;
    -pl)
      PLIST=1
      QUIET=1
      shift
      ;;
    -ps)
      PSHOW=1
      shift
      ;;
    -p)
      PSTATUS=1
      shift
      ;;
    -l)
      ELIST=1
      shift
      ;;
    -s)
      ESHOW=1
      shift
      ;;
    -S*)
      [[ "$1" != "-S" ]] && REXP=${1:2}
      ESHOW_ALL=1
      QUIET=1
      shift
      ;;
    -E)
      EEDIT=1
      shift
      ;;
    -Et)
      EEDIT_TEMPLATE=1
      shift
      ;;
    -a)
      ALIST=1
      QUIET=1
      shift
      ;;
    -ah)
      AHISTORY=1
      shift
      ;;
    -ai)
      AIMAGE=1
      shift
      ;;
    -an)
      ANOTE=1
      shift
      ;;
    -at)
      ATAGS=1
      shift
      ;;
    -al)
      ALOG=1
      shift
      ;;
    -h|-help|--help)
      HELP=1
      shift
      ;;
    -q)
      QUIET=1
      shift
      ;;
    --)
      shift
      ARGS2=$*
      break
      ;;
    *)
      OPTS2+=("$1")
      shift
      ;;
  esac
done

if [ $HELP -eq 1 ]; then
  echo "$(basename $0) -install              # install"
  echo "$(basename $0) -version              # version"
  echo "$(basename $0) -B                    # backup"
  echo "$(basename $0) -Bl                   # backup list"
  echo "$(basename $0) -L [-x]               # link show,run"
  echo ""
  echo "$(basename $0) -P                    # image pull"
  echo "$(basename $0) -ic                   # image chain"
  echo ""
  echo "$(basename $0) -init [-x]            # app init show,run"
  echo "$(basename $0) -r [opts2] [-- args2] # app run"
  echo "$(basename $0) -e [args2]            # app exec"
  echo "$(basename $0) -c                    # app create"
  echo "$(basename $0) -cu                   # app create unit"
  echo "$(basename $0) -cp                   # app create pcmk"
  echo "$(basename $0) -d                    # app delete"
  echo "$(basename $0) -du                   # app delete unit"
  echo "$(basename $0) -dp                   # app delete pcmk"
  echo "$(basename $0) -R                    # app restart"
  echo "$(basename $0) -Ru                   # app restart unit"
  echo "$(basename $0) -Rp                   # app restart pcmk"
  echo "$(basename $0) -a                    # app list"
  echo "$(basename $0) -ah                   # app history"
  echo "$(basename $0) -ai                   # app image"
  echo "$(basename $0) -an                   # app note"
  echo "$(basename $0) -at                   # app tag"
  echo "$(basename $0) -al                   # app log"
  echo ""
  echo "$(basename $0) -ul                   # unit list"
  echo "$(basename $0) -us                   # unit show"
  echo "$(basename $0) -u                    # unit status"
  echo ""
  echo "$(basename $0) -pl                   # pcmk list"
  echo "$(basename $0) -ps                   # pcmk show"
  echo "$(basename $0) -p                    # pcmk status"
  echo ""
  echo "$(basename $0) -l                    # env list"
  echo "$(basename $0) -s                    # env show"
  echo "$(basename $0) -S[rexp]              # env show all"
  echo "$(basename $0) -E                    # env edit"
  echo "$(basename $0) -Et                   # env edit with template"
  echo "$(basename $0)                       # env list"
  echo ""
  echo "opts:"
  echo "  -A  - container name"
  echo "  -V  - img version"
  echo "  -I  - img name"
  echo "  -Ed - env dir (edir)"
  echo "  -Bd - bin dir (bdir)"
  echo ""
  echo "env files: /usr/local/etc/cman.env $EDIR/\$A \$HOME/.cman.env .cman.env \$CMANENV"
  echo "env vars:"
  echo "  \$A   - container name"
  echo "  \$V   - img version"
  echo "  \$I   - img name"
  echo "  \$APN - app name"
  echo "  \$API - app id"
  echo ""
  echo "note:"
  echo "  cm -L -x            # link"
  echo ""
  echo "  ap-apn-api -init -x # init"
  echo ""
  echo "  ap-apn-api -E       # edit"
  echo "  ap-apn-api -P       # pull"
  echo ""
  echo "  --- deployment: docker"
  echo "  ap-apn-api -d       # delete container"
  echo "  ap-apn-api -r       # run foreground (test)"
  echo "  ap-apn-api -c       # run background"
  echo ""
  echo "  --- deployment: podman"
  echo "  ap-apn-api -du      # delete unit & container"
  echo "  ap-apn-api -r       # run foreground (test)"
  echo "  ap-apn-api -c       # run background"
  echo "  ap-apn-api -cu      # create unit & container"
  echo ""
  echo "  --- deployment: pacemaker"
  echo "  ap-apn-api -dp      # delete package & container"
  echo "  ap-apn-api -r       # run foreground (test)"
  echo "  ap-apn-api -cp      # create package & container"
  exit 0
fi

#
# stage: CONFIG
#
ipa() {
  ifconfig $1 | grep mask | awk '{print $2}'
}

for f in /usr/local/etc/cman.env $EDIR/$A $HOME/.cman.env .cman.env $CMANENV; do
  if [ -e $f ]; then
    [[ "$EFILE" != "" ]] && EFILE="$EFILE $f" || EFILE="$f"
    . ${f}
  fi
done

if [ "$ETEMPLATE" = "" ]; then
ETEMPLATE=': ${V:=m.m.p}
: ${I:=scr.dc.local/is/repo:$V}
OPTS=(
)'
fi

if [ -z $PCMK_TYPE ]; then
  if [ $(type -t podman) ]; then
    PCMK_TYPE="ocf:heartbeat:podman"
  else
    PCMK_TYPE="ocf:heartbeat:docker"
  fi
fi

: ${PCMK_ATTR:="image=$I name=$A allow_pull=true"}

#
# stage: VERSION
#
if [ $VERSION -eq 1 ]; then
  echo "${0##*/}  $VERSION_BIN"
  if [ $(type -t docker) ]; then
    set -ex
    docker --version
    { set +ex; } 2>/dev/null
  fi
  if [ $(type -t podman) ]; then
    set -ex
    podman --version
    { set +ex; } 2>/dev/null
  fi
  if [ $(type -t containerd) ]; then
    set -ex
    containerd --version
    { set +ex; } 2>/dev/null
  fi
  exit 0
fi

#
# stage: INSTALL
#
if [ $INSTALL -eq 1 ]; then
  if [ -f cman.sh ]; then
    for d in /usr/local/bin /pub/pkb/kb/data/999212-cman/999212-000020_cman_script /pub/pkb/pb/playbooks/999212-cman/files; do
      if [ -d $d ]; then
        set -ex
        rsync -ai cman.sh $d/cman.sh
        rsync -ai cman.sh $d/cman-exec.sh
        { set +ex; } 2>/dev/null
      fi
    done
  fi
  exit 0
fi

#
# stage: INFO
#
if [ $QUIET -eq 0 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: INFO"

  [[ -n $INFO ]] && echo "info      = $INFO"
  echo "cwd       = $(pwd -P)"
  echo "efile     = ${EFILE:-[none]}"
  echo "App       = ${A:-[none]}"
  echo "Ver       = ${V:-[none]}"
  echo "Img       = ${I:-[none]}"
  echo "APN       = ${APN:-[none]}"
  echo "API       = ${API:-[none]}"
  echo "wdir      = ${WDIR:-[none]}"
  echo "edir      = ${EDIR:-[none]}"
  echo "bdir      = ${BDIR:-[none]}"
  echo "comm      = ${COMM:-[none]}"
  echo "run_fg    = ${RUN_FG:-[none]}"
  echo "run_bg    = ${RUN_BG:-[none]}"
  echo "pcmk_type = ${PCMK_TYPE:-[none]}"
  echo "pcmk_attr = ${PCMK_ATTR:-[none]}"

  if [ "$OPTS" != "" ]; then
    echo "opts      = $(echo ${OPTS[@]}|sed 's/--/\n--/g'|grep -v '^$'|sed '2,$s/^--/            --/')"
  else
    echo "opts      = [none]"
  fi
  if [ "$OPTS2" != "" ]; then
    echo "opts2     = ${OPTS2[@]}"
  else
    echo "opts2     = [none]"
  fi

  echo "args      = ${ARGS:-[none]}"
  echo "args2     = ${ARGS2:-[none]}"

  if [ "$INIT" != "" ]; then
    echo -n "init      = "
    for cmd in "${INIT[@]}"; do
      echo $cmd
    done | sed '2,$s/^/            /'
  else
    echo "init      = [none]"
  fi

  if [ "$TAGS" != "" ]; then
    echo "tags      = $TAGS"
  fi

  if [ "$NOTE" != "" ]; then
    echo "note      = $NOTE"
  fi

  if [ "$DOCS" != "" ]; then
    echo -n "docs      = "
    echo "$DOCS" | sed 's/\!\!/\n/g' | sed '2,$ s/^/         /'
  fi
fi

#
# stage: LINK
#
if [ $LINK -ne 0 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: LINK"

  if [ ! -d $EDIR ]; then
    echo $ID: directory not found: $EDIR
    exit 1
  fi
  if [ ! -d $BDIR ]; then
    echo $ID: directory not found: $BDIR
    exit 1
  fi

  ls $EDIR/ | \
  while read E; do
    if [ -x $EDIR/$E ]; then
      continue
    fi
    if grep -q EXEC=1 $EDIR/$E; then
      LSRC=${COMM%.sh}-exec.sh
    else
      LSRC=${COMM}
    fi
    if [ ! -f $BDIR/$E ]; then
      if [ $EVAL -ne 0 ]; then
        set -ex
        ln -svr $LSRC $BDIR/$E
        { set +ex; } 2>/dev/null
      else
        echo "ln -svr $LSRC $BDIR/$E"
      fi
    else
      echo "# ln -svr $LSRC $BDIR/$E"
    fi
  done
fi

#
# stage: IMAGE-PULL
#
if [ $PULL -ne 0 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: IMAGE-PULL"

  set -ex
  docker image pull $I
  { set +ex; } 2>/dev/null
fi

#
# stage: IMAGE-CHAIN
#
if [ $CHAIN -ne 0 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: IMAGE-CHAIN"

  docker image history --format "table {{printf \"%.1000s\" .CreatedBy}}" --no-trunc $I | \
    grep ENV | grep INFO_DATE | awk -FENV '{print $2}' | xargs -L1 | \
    sed 's/INFO_//g' | sed 's/DATE=//g' | column -t
  true
fi

#
# stage: APP-INIT
#
if [ $AINIT -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-INIT (EVAL=$EVAL)"

  for cmd in "${INIT[@]}"; do
    if [ $EVAL -eq 0 ]; then
      echo $cmd
    else
      set -ex
      eval $cmd
      { set +ex; } 2>/dev/null
    fi
  done
fi

#
# stage: APP-RUN
#
if [ $RUN -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-RUN"

  if [ "$WDIR" != "" ]; then
    set -ex
    cd $WDIR
    { set +ex; } 2>/dev/null
  fi

  OL=$(echo "${OPTS[@]}" "${OPTS2[@]}" --name $A)
  AL=$(echo $ARGS $ARGS2)

  set -ex
  docker container run $RUN_FG $OL $I $AL
  { set +ex; } 2>/dev/null
fi

#
# stage: EXEC
#
if [ $EXEC -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: EXEC"

  if [ "$WDIR" != "" ]; then
    set -ex
    cd $WDIR
    { set +ex; } 2>/dev/null
  fi

  if [ "$ARGS" = "" -a "$ARGS2" = "" ]; then
    echo docker container exec -ti $A bash --login
    docker container exec -ti $A bash --login
  else
    ARGSL=$(echo $ARGS $ARGS2)
    echo docker container exec -i $A bash --login "<<< \"$ARGSL\""
    docker container exec -i $A bash --login <<< "$ARGSL"
  fi
fi

#
# stage: APP-CREATE
#
if [ $CREATE -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-CREATE"

  set -ex
  docker container run $RUN_BG "${OPTS[@]}" --name $A $I $ARGS ${@:2}
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-CREATE-UNIT
#
if [ $CREATE_UNIT -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-CREATE-UNIT"

  set -ex
  cd /etc/systemd/system
  podman generate systemd --new --name $A -f
  systemctl daemon-reload
  systemctl enable --now container-$A.service
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-CREATE-PCMK
#
if [ $CREATE_PCMK -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-CREATE-PCMK"

  run_opts="$(echo ${OPTS[@]})"

  set -ex
  pcs resource create $A $PCMK_TYPE \
    $PCMK_ATTR \
    run_opts="$run_opts"
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-DELETE
#
if [ $DELETE -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-DELETE"

  set -ex
  docker container stop $A
  docker container rm $A
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-DELETE-UNIT
#
if [ $DELETE_UNIT -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-DELETE-UNIT"

  set -ex
  cd /etc/systemd/system
  if [ -f container-$A.service ]; then
    systemctl disable --now container-$A.service
    rm -fv container-$A.service
    systemctl daemon-reload
    systemctl reset-failed container-$A.service
  fi
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-DELETE-PCMK
#
if [ $DELETE_PCMK -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-DELETE-PCMK"

  set -ex
  pcs resource delete $A
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-RESTART
#
if [ $RESTART -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-RESTART"

  set -ex
  docker container stop --wait 30 $A
  docker container start $A
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-RESTART-UNIT
#
if [ $RESTART_UNIT -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-RESTART-UNIT"

  set -ex
  cd /etc/systemd/system
  if [ -f container-$A.service ]; then
    systemctl stop container-$A.service
    systemctl start container-$A.service
  fi
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-RESTART-PCMK
#
if [ $RESTART_PCMK -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-RESTART-PCMK"

  set -ex
  pcs resource restart $A
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-LIST
#
if [ $ALIST -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-LIST"

  set -ex
  docker container ls -a
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-HISTORY
#
if [ $AHISTORY -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-HISTORY"

  set -ex
  docker container ls -a --filter name=$A
  { set +ex; } 2>/dev/null
fi

#
# stage: APP-IMAGE
#
if [ $AIMAGE -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-IMAGE"

  (
  echo App Image Ver
  for f in $(ls -A $EDIR); do
    (
      unset I
      unset V
      . $EDIR/$f
      [[ "$I" = "" ]] && I="-"
      [[ "$V" = "" ]] && V="-"
      echo $(basename $f) $I $V
    )
  done
  ) | column -t
fi

#
# stage: APP-NOTE
#
if [ $ANOTE -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-NOTE"

  (
  echo App Note
  for f in $(ls -A $EDIR); do
    (
      unset NOTE
      . $EDIR/$f
      [[ "$NOTE" = "" ]] && NOTE="-"
      XNOTE=$(echo $NOTE|sed 's/ /__SPACE__/g')
      echo $(basename $f) $XNOTE
    )
  done
  ) | column -t | sed 's/__SPACE__/ /g'
fi

#
# stage: APP-TAGS
#
if [ $ATAGS -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-TAGS"

  (
  echo App Tags
  for f in $(ls -A $EDIR); do
    (
      unset TAGS
      . $EDIR/$f
      [[ "$TAGS" = "" ]] && TAGS="-"
      XTAGS=$(echo $TAGS|sed 's/ /__SPACE__/g')
      echo $(basename $f) $XTAGS
    )
  done
  ) | column -t | sed 's/__SPACE__/ /g'
fi

#
# stage: APP-LOG
#
if [ $ALOG -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: APP-LOG"

  set -ex
  docker container logs -f $A
  { set +ex; } 2>/dev/null
fi

#
# stage: UNIT-LIST
#
if [ $ULIST -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: UNIT-LIST"

  set -ex
  systemctl list-units container-\*
  { set +ex; } 2>/dev/null
fi

#
# stage: UNIT-SHOW
#
if [ $USHOW -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: UNIT-SHOW"

  set -ex
  systemctl cat container-$A.service --no-pager
  { set +ex; } 2>/dev/null
fi

#
# stage: UNIT-STATUS
#
if [ $USTATUS -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: UNIT-STATUS"

  set -ex
  systemctl status container-$A.service --no-pager -l
  { set +ex; } 2>/dev/null
fi

#
# stage: PCMK-LIST
#
if [ $PLIST -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: PCMK-LIST"

  set -ex
  pcs resource | column -t
  { set +ex; } 2>/dev/null
fi

#
# stage: PCMK-SHOW
#
if [ $PSHOW -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: PCMK-SHOW"

  set -ex
  pcs resource show $A
  { set +ex; } 2>/dev/null
fi

#
# stage: PCMK-STATUS
#
if [ $PSTATUS -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: PCMK-STATUS"

  set -ex
  crm_resource --why --resource $A
  { set +ex; } 2>/dev/null
fi

#
# stage: ENV-LIST
#
if [ $ELIST -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: ENV-LIST"

  if [ -d $EDIR ]; then
    set -ex
    ls -log $EDIR/
    { set +ex; } 2>/dev/null
  fi
fi

#
# stage: ENV-SHOW
#
if [ $ESHOW -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: ENV-SHOW"

  if [ ! -f $EDIR/$A ]; then
    echo file not found: $EDIR/$A
  else
    set -ex
    cat $EDIR/$A
    { set +ex; } 2>/dev/null
  fi
fi

#
# stage: ENV-SHOW-ALL
#
if [ $ESHOW_ALL -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: ENV-SHOW-ALL (rexp: *$REXP*)"

  if [ -d $EDIR ]; then
    (
    for f in $EDIR/*$REXP*; do
      if [ -f $f ]; then
        echo | xargs -L1 -t cat $f 2>&1
        echo
      fi
    done
    ) | sed '${/^$/d;}'
  fi
fi

#
# stage: ENV-EDIT
#
if [ $EEDIT -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: ENV-EDIT"

  if [ ! -d $EDIR ]; then
    echo directory not found: $EDIR
  else
    if [ "$EDITOR" != "" ]; then
      set -ex
      $EDITOR $EDIR/$A
      { set +ex; } 2>/dev/null
    else
      set -ex
      vi $EDIR/$A
      { set +ex; } 2>/dev/null
    fi
  fi
fi

#
# stage: ENV-EDIT-TEMPLATE
#
if [ $EEDIT_TEMPLATE -eq 1 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: ENV-EDIT-TEMPLATE"

  if [ ! -d $EDIR ]; then
    echo directory not found: $EDIR
  else
    if [ ! -f $EDIR/$A ]; then
      echo create file: $EDIR/$A
      echo "$ETEMPLATE" > $EDIR/$A
    else
      echo file exists: $EDIR/$A
    fi
    set -ex
    vi $EDIR/$A
    { set +ex; } 2>/dev/null
  fi
fi

#
# stage: BACKUP
#
if [ $BACKUP -ne 0 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: BACKUP"

  if [ ! -d $DDIR ]; then
    set -x
    mkdir -p $DDIR
    { set +x; } 2>/dev/null
  fi

  F=${DDIR}/cman-$(hostname -s)-$(date "+%Y%m%d%H%M").tar

  set -x
  cd /usr/local
  tar cf $F etc/cman* bin/cman*
  gzip -f $F
  { set +x; } 2>/dev/null
fi

#
# stage: BACKUP-LIST
#
if [ $BACKUP_LIST -ne 0 ]; then
  (( $s != 0 )) && echo; ((++s))
  echo "$ID: stage: BACKUP-LIST"

  set -x
  tree --noreport -F -h -C -L 1 ${DDIR}
  { set +x; } 2>/dev/null
fi
