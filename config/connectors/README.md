# Connector Configurations

This directory contains configuration files for various data source connectors.

## Directory Structure

```
connectors/
├── databases/          # Database connector configurations
│   ├── snowflake-ingest.yaml
│   ├── snowflake-lineage.yaml
│   └── snowflake-query-usage.yaml
└── pipelines/          # Pipeline connector configurations
    └── fivetran.yaml
```

## Usage

1. **Configure Data Sources**: Edit the YAML files to match your environment
2. **Add New Connectors**: Create new configuration files following OpenMetadata connector documentation
3. **Apply Configurations**: Use the OpenMetadata UI or API to import these configurations

## Connector Types

### Database Connectors
- **Snowflake**: Complete configuration for data ingestion, lineage tracking, and query usage analysis

### Pipeline Connectors  
- **Fivetran**: Configuration for pipeline metadata ingestion

## Configuration Guidelines

1. **Sensitive Data**: Store credentials in environment variables, not in configuration files
2. **Validation**: Test configurations in development before applying to production
3. **Documentation**: Comment your configurations for team understanding
4. **Version Control**: Track changes to understand configuration evolution

## Adding New Connectors

1. Create configuration file in appropriate subdirectory
2. Follow OpenMetadata connector documentation for specific connector type
3. Test configuration before deploying
4. Update this README with new connector information

For detailed connector configuration options, see the [OpenMetadata Connectors Documentation](https://docs.open-metadata.org/connectors).
