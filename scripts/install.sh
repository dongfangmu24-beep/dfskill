#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="https://github.com/dongfangmu24-beep/dfskill.git"
DEST_ROOT="${DF_SKILLS_ROOT:-${HOME}/.user_skills}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if ! command -v git >/dev/null 2>&1; then
  echo "错误：需要 git 才能安装东方。" >&2
  exit 1
fi

mkdir -p "$DEST_ROOT"
git clone --depth 1 "$REPO_URL" "$TMP_DIR/repo"
SOURCE="$TMP_DIR/repo"

if [[ ! -f "$SOURCE/SKILL.md" ]]; then
  echo "错误：仓库缺少主入口 SKILL.md。" >&2
  exit 1
fi

install_one() {
  local name="$1" src="$2" dest="$DEST_ROOT/$1" stage

  if [[ -L "$dest" ]]; then
    echo "跳过 $name：目标是符号链接。" >&2
    return 1
  fi

  if [[ -e "$dest" && ! -d "$dest" ]]; then
    echo "跳过 $name：目标不是目录。" >&2
    return 1
  fi

  if [[ -d "$dest" && ! -f "$dest/.dfskill-managed" ]]; then
    echo "跳过 $name：已有非本脚本管理的安装，避免覆盖。" >&2
    return 1
  fi

  stage="$(mktemp -d "$DEST_ROOT/.dfskill-stage-XXXXXX")"
  cp -R "$src"/. "$stage"/
  printf 'managed-by=dfskill\n' > "$stage/.dfskill-managed"

  if [[ -d "$dest" ]]; then
    local old="${dest}.backup.$(date +%s)"
    mv "$dest" "$old"
    if mv "$stage" "$dest"; then
      rm -rf "$old"
    else
      mv "$old" "$dest"
      return 1
    fi
  else
    mv "$stage" "$dest"
  fi

  echo "已安装：$name"
}

# 安装东方主入口
install_one dfskill "$SOURCE" || true

# 自动发现并安装所有子Skill
if [[ -d "$SOURCE/skills" ]]; then
  for skill_dir in "$SOURCE"/skills/*; do
    [[ -d "$skill_dir" && -f "$skill_dir/SKILL.md" ]] || continue

    name="$(basename "$skill_dir")"

    if [[ ! "$name" =~ ^[a-z][a-z0-9-]*$ ]]; then
      echo "跳过非法名称：$name" >&2
      continue
    fi

    [[ "$name" != "dfskill" ]] || continue
    install_one "$name" "$skill_dir" || true
  done
fi

echo "安装结束。请重新打开豆包工作会话，检查技能面板。"
