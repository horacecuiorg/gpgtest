#!/bin/bash
set -e

GPG_PASSPHRASE=${GPG_PASSPHRASE:-}
CONFIG_FILE="$(dirname "$0")/.fileconfig"


if [ ! -f "$CONFIG_FILE" ]; then
  echo "[decrypt] ERROR: Config file $CONFIG_FILE not found."
  exit 1
fi

echo "[decrypt] Reading files to decrypt from $CONFIG_FILE..."

while IFS= read -r line || [ -n "$line" ]; do
  file=$(echo "$line" | xargs)
  # 跳过空行和注释
  if [ -z "$file" ] || [[ "$file" =~ ^# ]]; then
    continue
  fi

  encrypted_file="${file}.gpg"
  decrypted_file="$file"

  if [ ! -f "$encrypted_file" ]; then
    echo "[decrypt] ERROR: Missing encrypted file $encrypted_file"
    exit 1
  fi

  echo "[decrypt] Decrypting $encrypted_file -> $decrypted_file"

  if [ -n "$GPG_PASSPHRASE" ]; then
    echo "$GPG_PASSPHRASE" | gpg --yes --batch --passphrase-fd 0 --pinentry-mode loopback \
      --output "$decrypted_file" --decrypt "$encrypted_file"
  else
    gpg --yes --batch --output "$decrypted_file" --decrypt "$encrypted_file"
  fi

  if [ ! -s "$decrypted_file" ]; then
    echo "[decrypt] ERROR: Decrypted file $decrypted_file is empty"
    exit 1
  fi
done < "$CONFIG_FILE"

echo "[decrypt] All files decrypted successfully."
