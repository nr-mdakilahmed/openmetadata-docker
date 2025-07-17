#!/bin/bash

# Security Audit Script for OpenMetadata Docker Project
# Performs comprehensive security checks and vulnerability scans

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_error() {
    echo -e "${RED}🚨 CRITICAL: $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  INFO: $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ PASSED: $1${NC}"
}

echo "🔒 OpenMetadata Security Audit"
echo "=============================================="

# Check for hardcoded secrets in config files
echo ""
echo "🔍 Scanning for hardcoded secrets..."

# Check for JWT tokens
JWT_FOUND=$(grep -r "eyJ" config/ 2>/dev/null || true)
if [ -n "$JWT_FOUND" ]; then
    log_error "JWT tokens found in config files!"
    echo "$JWT_FOUND"
else
    log_success "No JWT tokens in config files"
fi

# Check for API keys
API_KEYS=$(grep -r "api.*key.*=" config/ | grep -v "\${" 2>/dev/null || true)
if [ -n "$API_KEYS" ]; then
    log_error "Hardcoded API keys found!"
    echo "$API_KEYS"
else
    log_success "No hardcoded API keys in config files"
fi

# Check for passwords
PASSWORDS=$(grep -r "password.*=" config/ | grep -v "\${" 2>/dev/null || true)
if [ -n "$PASSWORDS" ]; then
    log_error "Hardcoded passwords found!"
    echo "$PASSWORDS"
else
    log_success "No hardcoded passwords in config files"
fi

# Check .env file permissions
echo ""
echo "📁 Checking file permissions..."
if [ -f .env ]; then
    ENV_PERMS=$(stat -f %A .env 2>/dev/null || stat -c %a .env 2>/dev/null)
    if [ "$ENV_PERMS" != "600" ] && [ "$ENV_PERMS" != "644" ]; then
        log_warning ".env file permissions are $ENV_PERMS (consider 600 for better security)"
    else
        log_success ".env file permissions are appropriate"
    fi
fi

# Check for placeholder values in .env
echo ""
echo "🔧 Checking environment configuration..."
PLACEHOLDERS=$(grep "YOUR_.*_HERE" .env 2>/dev/null || true)
if [ -n "$PLACEHOLDERS" ]; then
    log_warning "Placeholder values found in .env:"
    echo "$PLACEHOLDERS" | sed 's/^/  /'
else
    log_success "No placeholder values in .env"
fi

# Check for world-readable files
echo ""
echo "🔐 Checking file security..."
READABLE_FILES=$(find . -type f -perm +004 -name "*.env*" -o -name "*.key" -o -name "*.pem" 2>/dev/null || true)
if [ -n "$READABLE_FILES" ]; then
    log_warning "World-readable sensitive files found:"
    echo "$READABLE_FILES" | sed 's/^/  /'
else
    log_success "No world-readable sensitive files"
fi

# Check for large files that shouldn't be committed
echo ""
echo "📊 Checking for large files..."
LARGE_FILES=$(find . -type f -size +50M ! -path "./docker-volume/*" 2>/dev/null || true)
if [ -n "$LARGE_FILES" ]; then
    log_warning "Large files found (>50MB):"
    echo "$LARGE_FILES" | sed 's/^/  /'
else
    log_success "No large files outside docker-volume"
fi

# Check Docker Compose security
echo ""
echo "🐳 Checking Docker Compose security..."

# Check for hardcoded passwords in docker-compose
DOCKER_SECRETS=$(grep -E "password|secret|key" docker-compose.yml | grep -v "\${" || true)
if [ -n "$DOCKER_SECRETS" ]; then
    log_warning "Potential hardcoded secrets in docker-compose.yml:"
    echo "$DOCKER_SECRETS" | sed 's/^/  /'
else
    log_success "No hardcoded secrets in docker-compose.yml"
fi

# Check for privileged containers
PRIVILEGED=$(grep -i "privileged.*true" docker-compose.yml || true)
if [ -n "$PRIVILEGED" ]; then
    log_warning "Privileged containers found"
else
    log_success "No privileged containers"
fi

# Git security check
echo ""
echo "📝 Checking Git configuration..."
if [ -d .git ]; then
    # Check if .env is tracked
    ENV_TRACKED=$(git ls-files | grep "^\.env$" || true)
    if [ -n "$ENV_TRACKED" ]; then
        log_error ".env file is tracked by Git! This is a critical security risk!"
    else
        log_success ".env file is not tracked by Git"
    fi
    
    # Check for secrets in git history
    SECRET_HISTORY=$(git log --all --full-history -- .env 2>/dev/null | head -1 || true)
    if [ -n "$SECRET_HISTORY" ]; then
        log_warning ".env file found in Git history - consider cleaning history"
    else
        log_success "No .env file in Git history"
    fi
else
    log_info "Not a Git repository"
fi

# Network security check
echo ""
echo "🌐 Checking network configuration..."
HTTP_ENDPOINTS=$(grep -r "http://" config/ || true)
if [ -n "$HTTP_ENDPOINTS" ]; then
    log_warning "HTTP (non-SSL) endpoints found:"
    echo "$HTTP_ENDPOINTS" | sed 's/^/  /'
    log_info "Consider using HTTPS in production"
else
    log_success "No HTTP endpoints found in configs"
fi

# Final summary
echo ""
echo "=============================================="
echo "🎯 Security Audit Complete"
echo ""
echo "📋 Next Steps for Production:"
echo "1. Replace all YOUR_*_HERE placeholders with real values"
echo "2. Set .env file permissions to 600 (chmod 600 .env)"
echo "3. Enable HTTPS/SSL for production deployment"
echo "4. Regularly rotate API keys and passwords"
echo "5. Monitor file permissions and access logs"
echo ""
echo "🔒 Remember: Never commit .env files or secrets to version control!"
