# 项目名称

## 项目简介

这里写项目简介，比如项目用途、技术栈等。

---

## 新机器环境初始化与解密说明

### 1. 安装 GPG

确保系统安装了 GPG：

```bash
gpg --version
```

如果未安装，请根据系统安装：

```bash
# Ubuntu / Debian
sudo apt update && sudo apt install -y gnupg

# macOS (使用 Homebrew)
brew install gnupg
```

---

### 2. 导出导入 GPG 私钥


导出私钥（包含私钥）
```bash
gpg --armor --export-secret-keys <your-key-id> > private-key.asc
```
导出私钥（包含公钥）
```bash
gpg --armor --export <your-key-id> > public-key.asc
```
获取你的 GPG 私钥文件（`private-key.asc`），然后导入：

```bash
gpg --import private-key.asc
```

验证导入成功：

```bash
gpg --list-secret-keys
```

---

### 3. 克隆项目

```bash
git clone <your-repo-url>
cd your-project
```

---

### 4. 赋予解密脚本执行权限

```bash
chmod +x decrypt.sh
```

---

### 5. 解密密文文件

如果你的私钥带密码，导出密码环境变量：

```bash
export GPG_PASSPHRASE="你的GPG解密密码"
```

然后运行解密脚本：

```bash
./decrypt.sh
```

脚本会自动解密所有配置文件，生成对应明文文件。

---

### 6. 验证解密结果

查看解密后的文件是否生成且不为空：

```bash
tree -a -I '.git'
cat .env
cat config/secrets.json
```

---

### 7. 后续操作

现在你可以正常运行项目或执行部署命令了。

---

## 注意事项

- 请妥善保管私钥文件和密码，避免泄露。
- 明文文件 `.env`、`config/secrets.json` 等都被 `.gitignore` 忽略，不会提交到 Git。
- 确保 GPG 版本支持 `--pinentry-mode loopback`（GPG 2.1 及以上）。

---

## 联系方式

如有疑问，请联系维护人员。


## 本地开发
- 将敏感明文文件放入对应目录
- 执行 `git config core.hooksPath .githooks` 启用自动加密
- 提交时自动生成 `.gpg` 文件并提交