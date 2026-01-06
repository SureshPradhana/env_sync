# 🔐 envm — Env Sync Manager

**envm** is a lightweight Bash utility that centralizes, version-controls, and safely manages `.env` files across multiple projects—without risking accidental exposure.

👉 **Read the full design & security rationale:**  
[envm blog](https://sureshpradhana.is-a.dev/blogs/simplify-environment-variable-management-bash-script)

---

## 🚀 Why envm?

Storing `.env` files inside project folders causes two common problems:

- **Secret leaks** from accidental Git commits
- **Lost configurations** when projects are deleted or moved

**envm** solves this by keeping all environment files in a local vault (`~/envs/`) and tracking changes with Git—separate from your project repositories.

---

## ✨ Features

- 📦 **Centralized Vault** — Store all `.env` files in one secure location
- 🕒 **Versioned History** — Automatic Git commits for every change
- 🔄 **Instant Sync** — Copy or move env files between projects
- 🔍 **Searchable** — Find environments by project name or pattern

---

## 🛠 Installation

Requires a Unix-like system (Linux or macOS), Bash, and Git. (WSL is required on Windows)

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/SureshPradhana/env_sync/main/envm -o ~/.local/bin/envm
chmod +x ~/.local/bin/envm
envm --help
```

### Optional: Add to PATH

Add ~/.local/bin to PATH by adding the following line to ~/.bashrc or ~/.zshrc:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## 📖 Usage

| Command              | Description                        |
| -------------------- | ---------------------------------- |
| `envm copy`          | Copy `.env` from project → vault   |
| `envm move`          | Move `.env` from vault → project   |
| `envm get <name>`    | Restore env for a specific project |
| `envm ls`            | List stored environments           |
| `envm dir <pattern>` | Search environments                |
| `envm --help`        | Show all available commands        |
