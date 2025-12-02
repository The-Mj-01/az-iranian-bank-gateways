#!/bin/bash
# Fix pre-commit cache directory permissions

echo "Fixing pre-commit cache directory permissions..."

# Change ownership of the entire cache directory (parent directory is owned by root)
sudo chown -R $(whoami):staff ~/.cache/

# Verify the fix
if [ $? -eq 0 ]; then
    echo "✅ Permissions fixed successfully!"
    echo "You can now run pre-commit commands."
    ls -la ~/.cache/ | head -3
else
    echo "❌ Failed to fix permissions. Please run manually:"
    echo "sudo chown -R $(whoami):staff ~/.cache/"
fi

