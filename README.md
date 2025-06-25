# Meltingplot MBL Series 3D Printer Config Files

This repository contains configuration files for the Meltingplot MBL Series 3D Printer. These files are intended to be used with the Duet 3D printer controller and include settings for various filaments, firmware, macros, and system configurations.

## Install

### Install on Raspberry PI SBC
To install these configuration files on a Duet 3D printer controller, follow these steps:

```bash
curl -s https://raw.githubusercontent.com/Meltingplot/BigPrint/refs/heads/duet-3.5.4-sbc/duetPi/install.sh | bash
```

### Install on Raspberry PI Zero 2W
To install the camPI, follow these steps:

```bash
curl -s https://raw.githubusercontent.com/Meltingplot/BigPrint/refs/heads/duet-3.5.4-sbc/camPi/install.sh | bash
```

## Repository Structure

### Filaments

The `filaments` directory contains subdirectories for different types of filaments. Each subdirectory includes configuration files specific to that filament type.

### Firmware

The `firmware` directory contains firmware files for the Duet 3D printer controller.

### Macros

The `macros` directory contains macro files for various printer operations.

### System

The `sys` directory contains system configuration files, including the main configuration file `config.g`.

### Web Interface

The `www` directory contains files for the Duet Web Control interface.

## Configuration Files

### Main Configuration File

The main configuration file is located at [duet-config/sys/config.g](duet-config/sys/config.g). This file is executed by the firmware on start-up and includes general preferences, network settings, and drive configurations.

### Machine Override

The machine-specific override file is located at [duet-config/sys/meltingplot/machine-override](duet-config/sys/meltingplot/machine-override). This file is loaded from `config.g` and can be used to set machine-specific settings, such as the rotation direction of specific stepper motors.

## License

This repository is licensed under the terms specified in the [LICENSE](LICENSE) file.

## Contributions

Contributions to this repository are welcome. Please ensure that any modifications or additions are in compliance with the license terms specified in the [LICENSE](LICENSE) file.