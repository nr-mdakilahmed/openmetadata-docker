#!/bin/bash

# Environment Variables Validation Script
# Validates that all required environment variables are set

echo "🔍 Validating OpenMetadata Environment Configuration..."
echo "============================================================"

# Source the .env file
if [ -f .env ]; then
    set -a
    source .env
    set +a
    echo "✅ .env file loaded successfully"
else
    echo "❌ .env file not found!"
    exit 1
fi

# Track validation status
VALIDATION_PASSED=true

# Function to check if a variable is set and not empty
check_var() {
    local var_name=$1
    local var_value=$(eval echo \$$var_name)
    local is_required=${2:-true}
    
    if [ -z "$var_value" ]; then
        if [ "$is_required" = true ]; then
            echo "❌ Required variable $var_name is not set or empty"
            VALIDATION_PASSED=false
        else
            echo "⚠️  Optional variable $var_name is not set"
        fi
    else
        # Don't show sensitive values, just confirm they're set
        if [[ "$var_name" == *"PASSWORD"* ]] || [[ "$var_name" == *"SECRET"* ]] || [[ "$var_name" == *"KEY"* ]] || [[ "$var_name" == *"TOKEN"* ]]; then
            echo "✅ $var_name is set (value hidden for security)"
        else
            echo "✅ $var_name = $var_value"
        fi
    fi
}

echo ""
echo "📋 OpenMetadata Core Configuration:"
echo "-----------------------------------"
check_var "OPENMETADATA_SERVER_HOST_PORT"
check_var "OPENMETADATA_JWT_TOKEN"

echo ""
echo "🗄️  Database Configuration:"
echo "---------------------------"
check_var "DB_HOST"
check_var "DB_PORT"
check_var "MYSQL_ROOT_PASSWORD"
check_var "MYSQL_DATABASE"
check_var "MYSQL_USER"
check_var "MYSQL_PASSWORD"

echo ""
echo "❄️  Snowflake Configuration:"
echo "----------------------------"
check_var "SNOWFLAKE_ACCOUNT"
check_var "SNOWFLAKE_USERNAME"
check_var "SNOWFLAKE_PASSWORD" false
check_var "SNOWFLAKE_WAREHOUSE"
check_var "SNOWFLAKE_DATABASE"
check_var "SNOWFLAKE_SCHEMA"
check_var "SNOWFLAKE_HOST_PORT"

echo ""
echo "🔄 Fivetran Configuration:"
echo "--------------------------"
check_var "FIVETRAN_SERVICE_NAME"
check_var "FIVETRAN_API_KEY" false
check_var "FIVETRAN_API_SECRET" false
check_var "FIVETRAN_HOST_PORT"
check_var "FIVETRAN_LIMIT"

echo ""
echo "🔍 Elasticsearch Configuration:"
echo "-------------------------------"
check_var "ELASTICSEARCH_HOST"
check_var "ELASTICSEARCH_PORT"

echo ""
echo "============================================================"
if [ "$VALIDATION_PASSED" = true ]; then
    echo "✅ All required environment variables are properly configured!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Update placeholder values (YOUR_*_HERE) with real credentials"
    echo "   2. Run: docker-compose up -d"
    echo "   3. Run: ./scripts/health-check.sh to verify services"
    exit 0
else
    echo "❌ Environment validation failed! Please check the missing variables above."
    exit 1
fi
