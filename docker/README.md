<!-- @format -->

# Quick install script for docker

**NOTE:**

- The script requires root or sudo privileges to run.
- The script attempts to detect your Linux distribution and version and configure your package management system for you, and does not allow you to customize most installation parameters.
- The script installs dependencies and recommendations without asking for confirmation. This may install a large number of packages, depending on the current configuration of your host machine.
- By default, the script installs the latest stable release of Docker, containerd, and runc. When using this script to provision a machine, this may result in unexpected major version upgrades of Docker. Always test (major) upgrades in a test environment before deploying to your production systems.
- The script is not designed to upgrade an existing Docker installation. When using the script to update an existing installation, dependencies may not be updated to the expected version, causing outdated versions to be used.

> :grey_exclamation:
> **Tip: preview script steps before running**:
>
> You can run the script with the `DRY_RUN=1` option to learn what steps the script will execute during installation:
>
> ```bash
> curl -fsSL https://get.docker.com -o get-docker.sh
> DRY_RUN=1 sh ./get-docker.sh
> ```

### Install Docker

```bash
sudo sh get-docker.sh
```

Docker is installed. The `docker` service starts automatically on Debian based distributions. On `RPM` based distributions, such as CentOS, Fedora, RHEL or SLES, you need to start it manually using the appropriate `systemctl` or `service` command. As the message indicates, non-root users cannot run Docker commands by default.
