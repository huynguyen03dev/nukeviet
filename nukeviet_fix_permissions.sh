#!/bin/bash

# NukeViet Comprehensive Permission Fix Script
# This script fixes all permission issues for NukeViet CMS
# Designed for local development environment (XAMPP/LAMPP)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get current user and web server user
CURRENT_USER=$(whoami)
WEB_USER="daemon"  # Default for XAMPP, could also be www-data, apache, or nobody

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}  NukeViet Permission Fix Script${NC}"
echo -e "${BLUE}===========================================${NC}"
echo -e "${YELLOW}Current user: ${CURRENT_USER}${NC}"
echo -e "${YELLOW}Web server user: ${WEB_USER}${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "index.php" ] || [ ! -d "modules" ]; then
    echo -e "${RED}Error: This script must be run from the NukeViet root directory${NC}"
    echo -e "${RED}Please cd to your NukeViet installation directory first${NC}"
    exit 1
fi

echo -e "${BLUE}Step 1: Setting directory permissions...${NC}"

# Set directory permissions (777 for web-writable in local development)
WEB_WRITABLE_DIRS=(
    "data/logs"
    "data/cache"
    "data/tmp"
    "data/config"
    "assets"
    "uploads"
)

# Set web-writable directories to 777 (for local development)
for dir in "${WEB_WRITABLE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${YELLOW}Setting web-writable permissions for: $dir${NC}"
        
        # Set directory itself
        chmod 777 "$dir"
        
        # Recursively set all subdirectories
        find "$dir" -type d -exec chmod 777 {} \; 2>/dev/null
        
        # Recursively set all files
        find "$dir" -type f -exec chmod 666 {} \; 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Set 777 permissions (recursive): $dir${NC}"
        else
            echo -e "${RED}✗ Failed to set permissions: $dir${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Directory not found (skipping): $dir${NC}"
    fi
done

echo ""
echo -e "${BLUE}Step 2: Setting file permissions...${NC}"

# Set .htaccess permissions (must be writable by web server)
if [ -f ".htaccess" ]; then
    echo -e "${YELLOW}Setting .htaccess permissions...${NC}"
    chmod 666 .htaccess
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Set .htaccess permissions (666)${NC}"
    else
        echo -e "${RED}✗ Failed to set .htaccess permissions${NC}"
    fi
else
    echo -e "${YELLOW}⚠ .htaccess file not found (skipping)${NC}"
fi

# Find and set permissions for all .htaccess files in subdirectories
echo -e "${YELLOW}Setting permissions for all .htaccess files...${NC}"
find . -name ".htaccess" -type f -exec chmod 666 {} \; 2>/dev/null
echo -e "${GREEN}✓ All .htaccess files set to 666${NC}"

# Set config file permissions
CONFIG_FILES=(
    "data/config/bpl_1.xml"
    "data/config/bpl_2.xml"
    "data/config/callingcodes.php"
    "data/config/config_geo.php"
    "data/config/config_global.php"
    "data/config/metatags.xml"
    "data/config/proxies.php"
    "data/config/robots.php"
    "data/config/rpc_services.php"
    "data/config/search_engine.xml"
    "data/config/search_engine_ping.xml"
    "data/config/server_config.json"
    "data/config/vnsubdivisions.php"
)

for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Setting permissions for: $file${NC}"
        chmod 666 "$file"  # 666 for web-writable config files
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Set permissions: $file${NC}"
        else
            echo -e "${RED}✗ Failed to set permissions: $file${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ File not found (skipping): $file${NC}"
    fi
done

echo ""
echo -e "${BLUE}Step 3: Setting ownership (if needed)...${NC}"

# Try to set ownership to current user and web server group
# This might require sudo, so we'll make it optional
echo -e "${YELLOW}Attempting to set ownership to ${CURRENT_USER}:${WEB_USER}...${NC}"

# Set ownership for web-writable directories
for dir in "${WEB_WRITABLE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        chown -R ${CURRENT_USER}:${WEB_USER} "$dir" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Set ownership: $dir${NC}"
        else
            echo -e "${YELLOW}! Could not set ownership for: $dir (may require sudo)${NC}"
        fi
    fi
done

echo ""
echo -e "${BLUE}Step 4: Final verification...${NC}"

# Check if directories are writable
echo -e "${YELLOW}Verifying write permissions...${NC}"

for dir in "${WEB_WRITABLE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        if [ -w "$dir" ]; then
            echo -e "${GREEN}✓ $dir is writable ($(stat -c "%a" "$dir"))${NC}"
        else
            echo -e "${RED}✗ $dir is NOT writable ($(stat -c "%a" "$dir"))${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ $dir does not exist${NC}"
    fi
done

# Check .htaccess
if [ -f ".htaccess" ]; then
    if [ -w ".htaccess" ]; then
        echo -e "${GREEN}✓ .htaccess is writable ($(stat -c "%a" ".htaccess"))${NC}"
    else
        echo -e "${RED}✗ .htaccess is NOT writable ($(stat -c "%a" ".htaccess"))${NC}"
    fi
else
    echo -e "${YELLOW}⚠ .htaccess does not exist${NC}"
fi

echo ""
echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}  Permission Fix Complete!${NC}"
echo -e "${GREEN}===========================================${NC}"
echo ""
echo -e "${YELLOW}Notes:${NC}"
echo -e "${YELLOW}• This script only sets permissions for existing files/directories${NC}"
echo -e "${YELLOW}• No files or directories are created${NC}"
echo -e "${YELLOW}• These permissions are set for local development${NC}"
echo -e "${YELLOW}• For production, use more restrictive permissions${NC}"
echo -e "${YELLOW}• If ownership issues persist, run with sudo:${NC}"
echo -e "${YELLOW}  sudo ./nukeviet_fix_permissions.sh${NC}"
echo ""
echo -e "${BLUE}You can now proceed with your NukeViet installation!${NC}"
