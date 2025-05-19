#!/bin/bash
set -e

CONFIG_FILE=".fileconfig"
GPG_RECIPIENT="cuiyinhu0808@qq.com"

echo "[encrypt] Reading files to encrypt from $CONFIG_FILE..."

if [ ! -f "$CONFIG_FILE" ]; then
  echo "[encrypt] ERROR: Config file $CONFIG_FILE not found."
  exit 1
fi

while IFS= read -r line || [ -n "$line" ]; do
  # 去除首尾空白
  file=$(echo "$line" | xargs)
  # 跳过空行和注释行
  if [ -z "$file" ] || [[ "$file" =~ ^# ]]; then
    continue
  fi

  if [ ! -f "$file" ]; then
    echo "[encrypt] Skipping: $file not found."
    continue
  fi

  output="$file.gpg"
  echo "[encrypt] Encrypting $file -> $output"

  gpg --yes --batch --output "$output" --encrypt --recipient "$GPG_RECIPIENT" "$file"

  if [ ! -s "$output" ]; then
    echo "[encrypt] ERROR: Encrypted file $output is empty!"
    exit 1
  fi
done < "$CONFIG_FILE"

echo "[encrypt] ✅ All files encrypted successfully."
