# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## High-level Architecture

This is a NukeViet CMS project, a PHP-based Content Management System. The application is structured in a modular way, with different functionalities encapsulated in modules.

### Key Directories:
*   `/modules`: Contains the different modules of the application. Each module has its own set of files for admin, public, and API-facing functionalty.
*   `/includes`: Core files of the NukeViet CMS. This includes Composer dependencies, and core libraries.
*   `/themes`: Holds the different themes available for the site. Each theme has its own configuration and assets.
*   `/data`: Contains user-generated content, logs, and other data.
*   `/docs`: Contains configuration files and project documentation.

### Namespaces:
The project uses PSR-4 autoloading, with the following namespaces:

*   `NukeViet\\`: Maps to `includes/vendor/vinades/nukeviet`
*   `NukeViet\\Api\\`: Maps to `includes/api`
*   `NukeViet\\Uapi\\`: Maps to `includes/uapi`
*   `NukeViet\\Module\\`: Maps to `modules`

## Common Development Tasks

### Installing Dependencies
This project uses Composer to manage PHP dependencies. To install them, run:

```bash
composer install
```

### Configuration
The main configuration files are located in the `docs/` directory:

*   `docs/config.php`: Contains database and site-specific configurations.
*   `docs/config_global.php`: Contains global configurations for the NukeViet CMS.

### Creating a New Module
1.  Create a new directory under `/modules`.
2.  Follow the NukeViet CMS module development guidelines to structure the module.
3.  Add the necessary files for admin, public, and API functionality.
4.  The module will be autoloaded under the `NukeViet\Module\` namespace.
