# Connect GitHub to Cursor IDE

## 1. Set up GitHub authentication

Choose one of these:

### Option A: Sign in with GitHub in Cursor (recommended)

1. Click your **account icon** (bottom-left in Cursor) or go to **File → Preferences → Settings**.
2. Open **Accounts** or search for **"GitHub"** in settings.
3. Click **Sign in with GitHub** and complete the browser flow.
4. Authorize Cursor when GitHub asks for permissions.

### Option B: Git credential manager (for Git push/pull)

- On Windows, **Git for Windows** often includes Git Credential Manager (GCM).
- When you first `git push` to GitHub, a browser or login window will open to authenticate.
- Or set a **Personal Access Token (PAT)**:
  1. GitHub → **Settings → Developer settings → Personal access tokens**.
  2. Generate a token (e.g. classic) with `repo` scope.
  3. When Git asks for a password, use the token instead of your GitHub password.

### Option C: GitHub CLI (optional)

1. Install: https://cli.github.com/ or `winget install GitHub.cli`
2. Run: `gh auth login` and follow the prompts (browser or token).

---

## 2. Connect GitHub to this IDE

- After signing in (Option A), Cursor uses your GitHub account for:
  - **Source Control** panel (commit, push, pull)
  - **GitHub Copilot** (if you use it)
  - Cloning and opening repos from GitHub

- No extra “connect project” step is needed once you’re signed in to GitHub in Cursor.

---

## 3. Test the connection

### In Cursor

1. Open **Source Control** (Ctrl+Shift+G) and confirm you see your repo and changes.
2. Try **Publish to GitHub** (if this repo isn’t on GitHub yet) or **Push** to an existing remote.

### From terminal (this project)

After adding a GitHub remote (see below):

```powershell
git remote -v
git push -u origin main
```

If a login window or browser opens and succeeds, the connection is working.

---

## 4. This project: Git and remote

This folder is now a Git repo. To connect it to GitHub:

1. Create a **new repository** on GitHub (github.com → New repository); do not add a README if the repo should stay empty.
2. Add the remote and push (replace `YOUR_USERNAME` and `YOUR_REPO`):

```powershell
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

When prompted, sign in with GitHub (browser or PAT). After a successful push, the connection is working.
