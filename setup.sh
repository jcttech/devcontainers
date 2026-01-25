#!/bin/bash
# Quick setup script for devcontainer templates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}Devcontainer Template Setup${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
}

print_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

list_templates() {
    echo "Available templates:"
    echo ""
    echo "  1) base    - General-purpose development (Node.js 20)"
    echo "  2) node    - Node.js/TypeScript development"
    echo "  3) python  - Python development (Python 3.11)"
    echo "  4) go      - Go development (Go 1.21)"
    echo ""
}

main() {
    print_header
    
    # Check if templates directory exists
    if [ ! -d "$TEMPLATES_DIR" ]; then
        print_error "Templates directory not found at $TEMPLATES_DIR"
        exit 1
    fi
    
    # Get target directory
    if [ -z "$1" ]; then
        echo "Usage: $0 <target-directory> [template-name]"
        echo ""
        list_templates
        exit 1
    fi
    
    TARGET_DIR="$1"
    
    # Create target directory if it doesn't exist
    if [ ! -d "$TARGET_DIR" ]; then
        print_info "Creating directory: $TARGET_DIR"
        mkdir -p "$TARGET_DIR"
    fi
    
    # Get template name
    TEMPLATE_NAME="$2"
    
    if [ -z "$TEMPLATE_NAME" ]; then
        list_templates
        read -p "Select a template (1-4): " choice
        case $choice in
            1) TEMPLATE_NAME="base" ;;
            2) TEMPLATE_NAME="node" ;;
            3) TEMPLATE_NAME="python" ;;
            4) TEMPLATE_NAME="go" ;;
            *) print_error "Invalid choice"; exit 1 ;;
        esac
    fi
    
    TEMPLATE_PATH="$TEMPLATES_DIR/$TEMPLATE_NAME"
    
    # Validate template exists
    if [ ! -d "$TEMPLATE_PATH" ]; then
        print_error "Template '$TEMPLATE_NAME' not found at $TEMPLATE_PATH"
        list_templates
        exit 1
    fi
    
    # Check if .devcontainer already exists
    if [ -d "$TARGET_DIR/.devcontainer" ]; then
        print_info "Found existing .devcontainer directory"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Cancelled"
            exit 0
        fi
        print_info "Removing existing .devcontainer"
        rm -rf "$TARGET_DIR/.devcontainer"
    fi
    
    # Copy template
    print_info "Copying $TEMPLATE_NAME template to $TARGET_DIR/.devcontainer"
    cp -r "$TEMPLATE_PATH" "$TARGET_DIR/.devcontainer"
    
    # Remove template README (keep only project README)
    if [ -f "$TARGET_DIR/.devcontainer/README.md" ]; then
        rm "$TARGET_DIR/.devcontainer/README.md"
    fi
    
    print_success "Template copied successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. cd $TARGET_DIR"
    echo "  2. code ."
    echo "  3. Click 'Reopen in Container' when prompted"
    echo ""
    
    # Template-specific instructions
    case $TEMPLATE_NAME in
        node)
            echo "For Node.js projects, ensure you have a package.json file"
            ;;
        python)
            echo "For Python projects, create a requirements.txt file with your dependencies"
            ;;
        go)
            echo "For Go projects, ensure you have a go.mod file"
            ;;
    esac
    
    print_success "Setup complete!"
}

main "$@"
