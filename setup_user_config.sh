#!/bin/bash

action=${1:-garbage}

diff_fname() {
  if [[ -z "$1" ]]; then
    echo "cannot diff without a file name"
    exit 1
  fi

  if [[ ! -z "$2" && "$2" == "temp" ]]; then
    diff "${HOME}/.${1}" "temp/${1}"
  else
    diff "${HOME}/.${1}" "${1}"
  fi
}

build_template() {
  vars=$(grep -e '{{.*}}' -o "$1" | sort -u)
  cp "$1" "temp/$1"
  for vstr in $vars; do
    v="${vstr//\{}"
    v="${v//\}}"
    v=$(echo -n "${v}" | tr -d '[:space:]')
    echo -n "What value for \$${v} [default: '${!v}']: "
    read vval
    if [[ -z "$vval" && -z "${!v}" ]]; then
      echo "Cannot infer \$${v} from environment"
      echo "Please try again but enter a value for \$${v}"
      exit 1
    elif [[ -z "$vval" && ! -z "${!v}" ]]; then
      vval="${!v}"
    fi
    replace_str="s/${vstr}/${vval}/g"
    if [[ "$vval" == *"/"* && "$vval" != *"@"* ]]; then
      replace_str="s@${vstr}@${vval}@g"
    fi
    sed -i '.bak' "${replace_str}" "temp/$1"
    rm "temp/$1.bak"
  done
}

cleanup_templates() {
  # Ignore all files that start with a '.'
  for f in $(ls -a temp/ | grep -ve '\..*'); do
    rm "temp/$f"
  done
}

touch_if_missing() {
  if [ ! -f "${HOME}/.$1" ]; then
    touch "${HOME}/.$1"
  fi
}

fname=""
case $action in
  bashrc)
    fname="bashrc"
    ;;
  git)
    fname="gitconfig"
    ;;
  profile)
    fname="profile"
    ;;
  vimrc)
    fname="vimrc"
    ;;
  *)
    echo "bad action name"
    exit 1
esac

touch_if_missing ${fname}
if [[ "$action" == "git" ]]; then
  touch_if_missing gitattributes
  touch_if_missing gitignore_global
  build_template ${fname}
  echo "diff of ${fname}"
  out=$(diff_fname ${fname} temp)
  echo "$(diff_fname ${fname} temp)"
  for extra in gitattributes gitignore_global; do
    echo "diff of $extra"
    out+=$(diff_fname ${extra})
    echo "$(diff_fname ${extra})"
  done
else
  echo "diff of ${fname}"
  out=$(diff_fname ${fname})
  echo "$(diff_fname ${fname})"
fi
if [[ -z "$out" ]]; then
  echo "No changes detected, exiting"
  exit
fi
echo -n "Is this acceptable? (y/N): "
read acceptance

if [[ "${acceptance}" == "y" || "${acceptance}" == "Y" ]]; then
  echo "Replacing any existing file at ${HOME}/${fname}"
  if [[ "${action}" == "git" ]]; then
    cp "temp/${fname}" "${HOME}/.${fname}"
    for extra in gitattributes gitignore_global; do
      echo "Replacing any existing file at ${HOME}/.${extra}"
      cp "${extra}" "${HOME}/.${extra}"
    done
    cleanup_templates
  else
    cp "${fname}" "${HOME}/.${fname}"
  fi
else
  echo "Not replacing existing file"
  if [[ "${action}" == "git" ]]; then
    cleanup_templates
  fi
  exit
fi
