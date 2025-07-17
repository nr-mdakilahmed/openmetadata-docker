#!/bin/bash
# OpenMetadata Management Script
# Provides common operations for OpenMetadata Docker setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COMPOSE_FILE="docker-compose.yml"
BACKUP_DIR="backups"

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

show_help() {
    echo "OpenMetadata Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start          Start all OpenMetadata services"
    echo "  stop           Stop all OpenMetadata services"
    echo "  restart        Restart all OpenMetadata services"
    echo "  status         Show status of all services"
    echo "  health         Run health check on all services"
    echo "  logs [service] Show logs (optionally for specific service)"
    echo "  backup         Create database backup"
    echo "  restore [file] Restore database from backup"
    echo "  clean          Remove all containers and volumes (DESTRUCTIVE)"
    echo "  update         Pull latest images and restart"
    echo "  shell [service] Open shell in service container"
    echo "  security       Run security audit and validation"
    echo "  help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs openmetadata_server"
    echo "  $0 backup"
    echo "  $0 restore backups/backup_20250717.sql"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

start_services() {
    log_info "Starting OpenMetadata services..."
    docker-compose -f $COMPOSE_FILE up -d
    log_success "Services started successfully!"
    echo ""
    log_info "Waiting for services to be ready..."
    sleep 10
    health_check
}

stop_services() {
    log_info "Stopping OpenMetadata services..."
    docker-compose -f $COMPOSE_FILE down
    log_success "Services stopped successfully!"
}

restart_services() {
    log_info "Restarting OpenMetadata services..."
    docker-compose -f $COMPOSE_FILE restart
    log_success "Services restarted successfully!"
    echo ""
    sleep 5
    health_check
}

show_status() {
    log_info "Service Status:"
    docker-compose -f $COMPOSE_FILE ps
}

health_check() {
    if [ -f "./scripts/health-check.sh" ]; then
        ./scripts/health-check.sh
    else
        log_warning "Health check script not found at ./scripts/health-check.sh"
        log_info "Checking basic container status..."
        docker-compose -f $COMPOSE_FILE ps
    fi
}

show_logs() {
    local service=$1
    if [ -n "$service" ]; then
        log_info "Showing logs for $service..."
        docker-compose -f $COMPOSE_FILE logs -f "$service"
    else
        log_info "Showing logs for all services..."
        docker-compose -f $COMPOSE_FILE logs -f
    fi
}

backup_database() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/openmetadata_backup_$timestamp.sql"
    
    log_info "Creating database backup..."
    
    if docker-compose -f $COMPOSE_FILE ps openmetadata_mysql | grep -q "Up"; then
        docker exec openmetadata_mysql mysqldump -u root -ppassword --all-databases > "$backup_file"
        log_success "Database backup created: $backup_file"
        
        # Compress backup
        gzip "$backup_file"
        log_success "Backup compressed: $backup_file.gz"
    else
        log_error "MySQL container is not running. Start services first."
        exit 1
    fi
}

restore_database() {
    local backup_file=$1
    
    if [ -z "$backup_file" ]; then
        log_error "Please specify backup file to restore"
        echo "Usage: $0 restore <backup_file>"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    log_warning "This will overwrite the current database!"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Restoring database from $backup_file..."
        
        # Handle compressed files
        if [[ "$backup_file" == *.gz ]]; then
            gunzip -c "$backup_file" | docker exec -i openmetadata_mysql mysql -u root -ppassword
        else
            docker exec -i openmetadata_mysql mysql -u root -ppassword < "$backup_file"
        fi
        
        log_success "Database restored successfully!"
        log_info "Restarting services to ensure consistency..."
        restart_services
    else
        log_info "Restore cancelled."
    fi
}

clean_everything() {
    log_warning "This will remove ALL containers, networks, and volumes!"
    log_warning "All data will be permanently lost!"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Stopping and removing all containers..."
        docker-compose -f $COMPOSE_FILE down -v --remove-orphans
        
        log_info "Removing unused Docker resources..."
        docker system prune -f
        
        log_success "Cleanup completed!"
    else
        log_info "Cleanup cancelled."
    fi
}

update_services() {
    log_info "Updating OpenMetadata services..."
    
    log_info "Pulling latest images..."
    docker-compose -f $COMPOSE_FILE pull
    
    log_info "Restarting services with new images..."
    docker-compose -f $COMPOSE_FILE up -d
    
    log_success "Update completed!"
    echo ""
    health_check
}

open_shell() {
    local service=${1:-openmetadata_server}
    
    log_info "Opening shell in $service container..."
    
    if docker-compose -f $COMPOSE_FILE ps "$service" | grep -q "Up"; then
        docker-compose -f $COMPOSE_FILE exec "$service" /bin/bash
    else
        log_error "Service $service is not running"
        exit 1
    fi
}

# Main script logic
case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        show_status
        ;;
    health)
        health_check
        ;;
    logs)
        show_logs "$2"
        ;;
    backup)
        backup_database
        ;;
    restore)
        restore_database "$2"
        ;;
    clean)
        clean_everything
        ;;
    update)
        update_services
        ;;
    shell)
        open_shell "$2"
        ;;
    security)
        log_info "Running security audit..."
        ./scripts/security-audit.sh
        echo ""
        log_info "Running environment validation..."
        ./scripts/validate-env.sh
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        log_error "No command specified"
        echo ""
        show_help
        exit 1
        ;;
    *)
        log_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
