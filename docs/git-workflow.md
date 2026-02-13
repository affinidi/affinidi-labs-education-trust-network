# Git Workflow Guide for Design Team

## 🌳 Branch Structure

We follow **Git Flow** with three main branches:

```
main (production)
  └── develop (development)
       └── feature/design-* (your work)
```

### Branch Descriptions

- **`main`** - Production code. **⚠️ NEVER COMMIT OR MERGE DIRECTLY TO MAIN**
- **`develop`** - Active development branch where all features merge
- **`feature/design-*`** - Your individual feature branches

---

## 🚀 Getting Started

### 1. Clone the Repository (First Time Only)

```bash
git clone <repository-url>
cd certizen-demo
```

### 2. Switch to Develop Branch

```bash
git checkout develop
```

---

## 📝 Daily Workflow

### Step 1: Pull Latest Changes from Develop

**Always do this before starting work each day!**

```bash
# Make sure you're on develop branch
git checkout develop

# Pull latest changes from remote
git pull origin develop
```

### Step 2: Create Your Feature Branch

Create a new branch for your feature/design work:

```bash
# Create and switch to new branch
git checkout -b feature/design-your-feature-name

# Example:
git checkout -b feature/design-homepage-layout
git checkout -b feature/design-credential-card
git checkout -b feature/design-color-scheme
```

**Naming Convention:**
- Always start with `feature/design-`
- Use lowercase
- Use hyphens to separate words
- Be descriptive but concise

### Step 3: Make Your Changes

Work on your files as usual (HTML, CSS, images, etc.)

### Step 4: Check What Changed

```bash
# See what files you modified
git status

# See the actual changes
git diff
```

### Step 5: Stage Your Changes

```bash
# Add all changed files
git add .

# Or add specific files
git add path/to/file.css
git add images/logo.png
```

### Step 6: Commit Your Changes

```bash
# Commit with a clear message
git commit -m "Add homepage hero section design"
git commit -m "Update credential card colors and spacing"
git commit -m "Add new university logo images"
```

**Good Commit Messages:**
- Start with a verb (Add, Update, Fix, Remove)
- Be specific about what you did
- Keep it under 50 characters if possible

### Step 7: Push Your Branch to Remote

```bash
# First time pushing this branch
git push -u origin feature/design-your-feature-name

# Subsequent pushes (after first time)
git push
```

---

## 🔄 Merging Your Work Back to Develop

### Option A: Using Pull Request (Recommended)

1. Push your branch to remote (see Step 7 above)
2. Go to GitHub/GitLab
3. Create a Pull Request from your branch to `develop`
4. Add description of your changes
5. Request review from team lead
6. Once approved, merge the PR

### Option B: Direct Merge (When Authorized)

```bash
# Make sure your feature branch is up to date
git checkout feature/design-your-feature-name
git pull origin develop  # Pull any new changes from develop

# Switch to develop branch
git checkout develop

# Pull latest changes
git pull origin develop

# Merge your feature branch
git merge feature/design-your-feature-name

# Push to remote
git push origin develop
```

### Option C: Rebase and Merge (Advanced)

```bash
# On your feature branch
git checkout feature/design-your-feature-name

# Rebase on top of latest develop
git rebase develop

# If conflicts occur, resolve them then:
git rebase --continue

# Push (may need force push after rebase)
git push -f origin feature/design-your-feature-name

# Switch to develop and merge
git checkout develop
git merge feature/design-your-feature-name
git push origin develop
```

---

## 🔄 Getting Others' Latest Changes

### While Working on Your Feature Branch

```bash
# Save your current work
git add .
git commit -m "WIP: Save progress"

# Switch to develop and pull
git checkout develop
git pull origin develop

# Go back to your branch and merge develop into it
git checkout feature/design-your-feature-name
git merge develop

# Or use rebase (cleaner history)
git rebase develop
```

### Quick Pull Latest Develop

```bash
# From your feature branch
git pull origin develop
```

---

## 🆘 Common Issues and Solutions

### Issue: Merge Conflicts

When files have conflicting changes:

```bash
# After pulling or merging, if you see conflicts:
# 1. Open the conflicted files
# 2. Look for conflict markers:
#    <<<<<<< HEAD
#    your changes
#    =======
#    their changes
#    >>>>>>> develop

# 3. Edit the file to keep what you want
# 4. Remove the conflict markers
# 5. Stage the resolved files
git add conflicted-file.css

# 6. Continue the merge/rebase
git commit  # for merge
git rebase --continue  # for rebase
```

### Issue: Accidentally Committed to Wrong Branch

```bash
# If you haven't pushed yet
git reset --soft HEAD~1  # Undo last commit, keep changes
git stash  # Save your changes
git checkout correct-branch
git stash pop  # Restore your changes
git add .
git commit -m "Your message"
```

### Issue: Need to Discard All Local Changes

```bash
# ⚠️ This will delete all uncommitted changes!
git checkout .
git clean -fd
```

### Issue: Want to Save Work Without Committing

```bash
# Save current work temporarily
git stash

# Do other work, switch branches, etc.

# Restore your saved work
git stash pop
```

---

## ⚠️ CRITICAL RULES - READ CAREFULLY

### 🚫 NEVER DO THESE:

1. **NEVER commit or merge directly to `main` branch**
   ```bash
   # ❌ DON'T DO THIS
   git checkout main
   git merge feature/design-something
   ```

2. **NEVER force push to `develop` or `main`**
   ```bash
   # ❌ DON'T DO THIS
   git push -f origin develop
   git push -f origin main
   ```

3. **NEVER delete someone else's branch without asking**

4. **NEVER commit large binary files** (videos, large PSDs)
   - Use Git LFS or store them elsewhere

### ✅ ALWAYS DO THESE:

1. **ALWAYS pull latest changes before starting work**
   ```bash
   git checkout develop
   git pull origin develop
   ```

2. **ALWAYS work on a feature branch, never directly on develop**

3. **ALWAYS write clear commit messages**

4. **ALWAYS push your branch to backup your work**

5. **ALWAYS ask for help if unsure!**

---

## 📋 Quick Reference Commands

```bash
# Check current branch
git branch

# Check status
git status

# Switch branch
git checkout branch-name

# Create and switch to new branch
git checkout -b feature/design-new-feature

# Pull latest changes
git pull origin develop

# Stage all changes
git add .

# Commit changes
git commit -m "Your message"

# Push changes
git push origin branch-name

# View commit history
git log --oneline

# See what changed
git diff
```

---

## 🆘 Need Help?

If you get stuck or see an error message you don't understand:

1. **Don't panic!** Most Git mistakes can be fixed
2. **Take a screenshot** of the error message
3. **Don't force push** or delete anything
4. **Ask a developer** on the team for help
5. Share what you were trying to do and the error message

---

## 📚 Useful Resources

- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Interactive Git Tutorial](https://learngitbranching.js.org/)
- [GitHub Desktop](https://desktop.github.com/) - GUI alternative to command line

---

## 🎯 Typical Design Workflow Example

```bash
# Monday morning - Start new feature
git checkout develop
git pull origin develop
git checkout -b feature/design-homepage-redesign

# Work on your files...
# Edit CSS, add images, etc.

# Save your progress
git add .
git commit -m "Add hero section with new layout"
git push -u origin feature/design-homepage-redesign

# Tuesday - Continue work
git add .
git commit -m "Update colors to match brand guidelines"
git push

# Wednesday - Pull teammate's changes
git checkout develop
git pull origin develop
git checkout feature/design-homepage-redesign
git merge develop

# Continue work...
git add .
git commit -m "Add responsive breakpoints for mobile"
git push

# Thursday - Feature complete, merge to develop
git checkout develop
git pull origin develop
git merge feature/design-homepage-redesign
git push origin develop

# Clean up (optional)
git branch -d feature/design-homepage-redesign
git push origin --delete feature/design-homepage-redesign
```

---

**Remember:** When in doubt, ask! It's better to ask than to accidentally break something. 🙂
