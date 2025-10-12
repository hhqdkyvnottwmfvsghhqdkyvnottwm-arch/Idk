# 1. Make project folder
mkdir -p FarhanToolBox/src FarhanToolBox/scripts
cd FarhanToolBox

# 2. Initialize Git
git init

# 3. Create files
echo "# FarhanToolBox 🚀" > README.md
echo "__pycache__/\n*.pyc\n.env\n.vscode/\n.DS_Store" > .gitignore
echo "MIT License\n\nCopyright (c) 2025 Farhan" > LICENSE
echo "#!/bin/bash\necho 'Setting up FarhanToolBox...'\npython3 src/main.py" > scripts/setup.sh
echo "print('Welcome to FarhanToolBox!')" > src/main.py
echo "def helper():\n    print('Helper function active!')" > src/utils.py

# 4. Make setup script executable
chmod +x scripts/setup.sh

# 5. Stage and commit
git add .
git commit -m "Initial project structure for FarhanToolBox"

# 6. Create repo on GitHub named FarhanToolBox (if not yet)
# https://github.com/Farhan/FarhanToolBox

# 7. Link and push
git remote add origin https://github.com/Farhan/FarhanToolBox.git
git branch -M main
git push -u origin main
