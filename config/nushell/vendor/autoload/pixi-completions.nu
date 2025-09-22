module completions {

  def "nu-complete pixi color" [] {
    [ "always" "never" "auto" ]
  }

  #  Pixi [version 0.54.2] - Developer Workflow and Environment Management for Multi-Platform, Language-Agnostic Workspaces.  Pixi is a versatile developer workflow tool designed to streamline the management of your workspace's dependencies, tasks, and environments. Built on top of the Conda ecosystem, Pixi offers seamless integration with the PyPI ecosystem.  Basic Usage:     Initialize pixi for a workspace:     $ pixi init     $ pixi add python numpy pytest      Run a task:     $ pixi task add test 'pytest -s'     $ pixi run test  Found a Bug or Have a Feature Request? Open an issue at: https://github.com/prefix-dev/pixi/issues  Need Help? Ask a question on the Prefix Discord server: https://discord.gg/kKV8ZxyzY4  For more information, see the documentation at: https://pixi.sh 
  export extern pixi [
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
    --list                    # List all installed commands (built-in and extensions)
    --version(-V)             # Print version
  ]

  def "nu-complete pixi add pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi add pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi add color" [] {
    [ "always" "never" "auto" ]
  }

  # Adds dependencies to the workspace
  export extern "pixi add" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    ...specs: string          # The dependency as names, conda MatchSpecs or PyPi requirements
    --host                    # The specified dependencies are host dependencies. Conflicts with `build` and `pypi`
    --build                   # The specified dependencies are build dependencies. Conflicts with `host` and `pypi`
    --pypi                    # The specified dependencies are pypi dependencies. Conflicts with `host` and `build`
    --platform(-p): string    # The platform for which the dependency should be modified
    --feature(-f): string     # The feature for which the dependency should be modified
    --git(-g): string         # The git url to use when adding a git dependency
    --branch: string          # The git branch
    --tag: string             # The git tag
    --rev: string             # The git revision
    --subdir(-s): string      # The subdirectory of the git repository to use
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi add pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi add pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --editable                # Whether the pypi requirement should be editable
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi auth color" [] {
    [ "always" "never" "auto" ]
  }

  # Login to prefix.dev or anaconda.org servers to access private channels
  export extern "pixi auth" [
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi auth color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi auth login color" [] {
    [ "always" "never" "auto" ]
  }

  # Store authentication information for a given host
  export extern "pixi auth login" [
    host: string              # The host to authenticate with (e.g. prefix.dev)
    --token: string           # The token to use (for authentication with prefix.dev)
    --username: string        # The username to use (for basic HTTP authentication)
    --password: string        # The password to use (for basic HTTP authentication)
    --conda-token: string     # The token to use on anaconda.org / quetz authentication
    --s3-access-key-id: string # The S3 access key ID
    --s3-secret-access-key: string # The S3 secret access key
    --s3-session-token: string # The S3 session token
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi auth login color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi auth logout color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove authentication information for a given host
  export extern "pixi auth logout" [
    host: string              # The host to remove authentication for
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi auth logout color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi auth help" [
  ]

  # Store authentication information for a given host
  export extern "pixi auth help login" [
  ]

  # Remove authentication information for a given host
  export extern "pixi auth help logout" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi auth help help" [
  ]

  def "nu-complete pixi build pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi build pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi build color" [] {
    [ "always" "never" "auto" ]
  }

  # Workspace configuration
  export extern "pixi build" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi build pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi build pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --target-platform(-t): string # The target platform to build for (defaults to the current platform)
    --build-platform: string  # The build platform to use for building (defaults to the current platform)
    --output-dir(-o): path    # The output directory to place the built artifacts
    --build-dir(-b): path     # The directory to use for incremental builds artifacts
    --clean(-c)               # Whether to clean the build directory before building
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi build color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi clean color" [] {
    [ "always" "never" "auto" ]
  }

  # Cleanup the environments
  export extern "pixi clean" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --environment(-e): string # The environment directory to remove
    --activation-cache        # Only remove the activation cache
    --build                   # Only remove the pixi-build cache
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi clean color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi clean cache color" [] {
    [ "always" "never" "auto" ]
  }

  # Clean the cache of your system which are touched by pixi
  export extern "pixi clean cache" [
    --pypi                    # Clean only the pypi related cache
    --conda                   # Clean only the conda related cache
    --mapping                 # Clean only the mapping cache
    --exec                    # Clean only `exec` cache
    --repodata                # Clean only the repodata cache
    --build-backends          # Clean only the build backends environments cache
    --build                   # Clean only the build related cache
    --yes(-y)                 # Answer yes to all questions
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi clean cache color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi clean help" [
  ]

  # Clean the cache of your system which are touched by pixi
  export extern "pixi clean help cache" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi clean help help" [
  ]

  def "nu-complete pixi completion shell" [] {
    [ "bash" "elvish" "fish" "nushell" "powershell" "zsh" ]
  }

  def "nu-complete pixi completion color" [] {
    [ "always" "never" "auto" ]
  }

  # Generates a completion script for a shell
  export extern "pixi completion" [
    --shell(-s): string@"nu-complete pixi completion shell" # The shell to generate a completion script for
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi completion color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi config color" [] {
    [ "always" "never" "auto" ]
  }

  # Configuration management
  export extern "pixi config" [
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi config color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi config edit color" [] {
    [ "always" "never" "auto" ]
  }

  # Edit the configuration file
  export extern "pixi config edit" [
    --local(-l)               # Operation on project-local configuration
    --global(-g)              # Operation on global configuration
    --system(-s)              # Operation on system configuration
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    editor?: string           # The editor to use, defaults to `EDITOR` environment variable or `nano` on Unix and `notepad` on Windows
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi config edit color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi config list color" [] {
    [ "always" "never" "auto" ]
  }

  # List configuration values
  export extern "pixi config list" [
    key?: string              # Configuration key to show (all if not provided)
    --json                    # Output in JSON format
    --local(-l)               # Operation on project-local configuration
    --global(-g)              # Operation on global configuration
    --system(-s)              # Operation on system configuration
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi config list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi config prepend color" [] {
    [ "always" "never" "auto" ]
  }

  # Prepend a value to a list configuration key
  export extern "pixi config prepend" [
    key: string               # Configuration key to set
    value: string             # Configuration value to (pre|ap)pend
    --local(-l)               # Operation on project-local configuration
    --global(-g)              # Operation on global configuration
    --system(-s)              # Operation on system configuration
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi config prepend color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi config append color" [] {
    [ "always" "never" "auto" ]
  }

  # Append a value to a list configuration key
  export extern "pixi config append" [
    key: string               # Configuration key to set
    value: string             # Configuration value to (pre|ap)pend
    --local(-l)               # Operation on project-local configuration
    --global(-g)              # Operation on global configuration
    --system(-s)              # Operation on system configuration
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi config append color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi config set color" [] {
    [ "always" "never" "auto" ]
  }

  # Set a configuration value
  export extern "pixi config set" [
    key: string               # Configuration key to set
    value?: string            # Configuration value to set (key will be unset if value not provided)
    --local(-l)               # Operation on project-local configuration
    --global(-g)              # Operation on global configuration
    --system(-s)              # Operation on system configuration
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi config set color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi config unset color" [] {
    [ "always" "never" "auto" ]
  }

  # Unset a configuration value
  export extern "pixi config unset" [
    key: string               # Configuration key to unset
    --local(-l)               # Operation on project-local configuration
    --global(-g)              # Operation on global configuration
    --system(-s)              # Operation on system configuration
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi config unset color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi config help" [
  ]

  # Edit the configuration file
  export extern "pixi config help edit" [
  ]

  # List configuration values
  export extern "pixi config help list" [
  ]

  # Prepend a value to a list configuration key
  export extern "pixi config help prepend" [
  ]

  # Append a value to a list configuration key
  export extern "pixi config help append" [
  ]

  # Set a configuration value
  export extern "pixi config help set" [
  ]

  # Unset a configuration value
  export extern "pixi config help unset" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi config help help" [
  ]

  def "nu-complete pixi exec pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi exec pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi exec color" [] {
    [ "always" "never" "auto" ]
  }

  # Run a command and install it in a temporary environment
  export extern "pixi exec" [
    ...command: string        # The executable to run, followed by any arguments
    --spec(-s): string        # Matchspecs of package to install. If this is not provided, the package is guessed from the command
    --with(-w): string        # Matchspecs of package to install, while also guessing a package from the command
    --channel(-c): string     # The channels to consider as a name or a url. Multiple channels can be specified by using this field multiple times
    --platform(-p): string    # The platform to create the environment for
    --force-reinstall         # If specified a new environment is always created even if one already exists
    --list: string            # Before executing the command, list packages in the environment Specify `--list=some_regex` to filter the shown packages
    --no-modify-ps1           # Disable modification of the PS1 prompt to indicate the temporary environment
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi exec pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi exec pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi exec color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global color" [] {
    [ "always" "never" "auto" ]
  }

  # Subcommand for global package management actions
  export extern "pixi global" [
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global add pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global add pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global add color" [] {
    [ "always" "never" "auto" ]
  }

  # Adds dependencies to an environment
  export extern "pixi global add" [
    ...specs: string          # The dependency as names, conda MatchSpecs
    --git: string             # The git url, e.g. `https://github.com/user/repo.git`
    --branch: string          # The git branch
    --tag: string             # The git tag
    --rev: string             # The git revision
    --subdir: string          # The subdirectory within the git repository
    --path: string            # The path to the local directory
    --environment(-e): string # Specifies the environment that the dependencies need to be added to
    --expose: string          # Add one or more mapping which describe which executables are exposed. The syntax is `exposed_name=executable_name`, so for example `python3.10=python`. Alternatively, you can input only an executable_name and `executable_name=executable_name` is assumed
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global add pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global add pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global edit color" [] {
    [ "always" "never" "auto" ]
  }

  # Edit the global manifest file
  export extern "pixi global edit" [
    editor?: string           # The editor to use, defaults to `EDITOR` environment variable or `nano` on Unix and `notepad` on Windows
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global edit color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global install pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global install pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global install color" [] {
    [ "always" "never" "auto" ]
  }

  # Installs the defined packages in a globally accessible location and exposes their command line applications.
  export extern "pixi global install" [
    ...specs: string          # The dependency as names, conda MatchSpecs
    --git: string             # The git url, e.g. `https://github.com/user/repo.git`
    --branch: string          # The git branch
    --tag: string             # The git tag
    --rev: string             # The git revision
    --subdir: string          # The subdirectory within the git repository
    --path: string            # The path to the local directory
    --channel(-c): string     # The channels to consider as a name or a url. Multiple channels can be specified by using this field multiple times
    --platform(-p): string    # The platform to install the packages for
    --environment(-e): string # Ensures that all packages will be installed in the same environment
    --expose: string          # Add one or more mapping which describe which executables are exposed. The syntax is `exposed_name=executable_name`, so for example `python3.10=python`. Alternatively, you can input only an executable_name and `executable_name=executable_name` is assumed
    --with: string            # Add additional dependencies to the environment. Their executables will not be exposed
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global install pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global install pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --force-reinstall         # Specifies that the environment should be reinstalled
    --no-shortcuts            # Specifies that no shortcuts should be created for the installed packages
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global install color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global uninstall pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global uninstall pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global uninstall color" [] {
    [ "always" "never" "auto" ]
  }

  # Uninstalls environments from the global environment.
  export extern "pixi global uninstall" [
    ...environment: string    # Specifies the environments that are to be removed
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global uninstall pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global uninstall pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global uninstall color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global remove pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global remove pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Removes dependencies from an environment
  export extern "pixi global remove" [
    ...packages: string       # Specifies the package that should be removed
    --environment(-e): string # Specifies the environment that the dependencies need to be removed from
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global remove pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global remove pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global list pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global list pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global list sort_by" [] {
    [ "size" "name" ]
  }

  def "nu-complete pixi global list color" [] {
    [ "always" "never" "auto" ]
  }

  # Lists global environments with their dependencies and exposed commands. Can also display all packages within a specific global environment when using the --environment flag.
  export extern "pixi global list" [
    regex?: string            # List only packages matching a regular expression. Without regex syntax it acts like a `contains` filter
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global list pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global list pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --environment(-e): string # Allows listing all the packages installed in a specific environment, with an output similar to `pixi list`
    --sort-by: string@"nu-complete pixi global list sort_by" # Sorting strategy for the package table of an environment
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global sync pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global sync pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global sync color" [] {
    [ "always" "never" "auto" ]
  }

  # Sync global manifest with installed environments
  export extern "pixi global sync" [
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global sync pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global sync pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global sync color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global expose color" [] {
    [ "always" "never" "auto" ]
  }

  # Interact with the exposure of binaries in the global environment
  export extern "pixi global expose" [
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global expose color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global expose add pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global expose add pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global expose add color" [] {
    [ "always" "never" "auto" ]
  }

  # Add exposed binaries from an environment to your global environment
  export extern "pixi global expose add" [
    ...mappings: string       # Add mapping which describe which executables are exposed. The syntax is `exposed_name=executable_name`, so for example `python3.10=python`. Alternatively, you can input only an executable_name and `executable_name=executable_name` is assumed
    --environment(-e): string # The environment to which the binaries should be exposed
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global expose add pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global expose add pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global expose add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global expose remove pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global expose remove pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global expose remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove exposed binaries from the global environment
  export extern "pixi global expose remove" [
    ...EXPOSED_NAME: string   # The exposed names that should be removed Can be specified multiple times
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global expose remove pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global expose remove pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global expose remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi global expose help" [
  ]

  # Add exposed binaries from an environment to your global environment
  export extern "pixi global expose help add" [
  ]

  # Remove exposed binaries from the global environment
  export extern "pixi global expose help remove" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi global expose help help" [
  ]

  def "nu-complete pixi global shortcut color" [] {
    [ "always" "never" "auto" ]
  }

  # Interact with the shortcuts on your machine
  export extern "pixi global shortcut" [
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global shortcut color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global shortcut add pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global shortcut add pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global shortcut add color" [] {
    [ "always" "never" "auto" ]
  }

  # Add a shortcut from an environment to your machine.
  export extern "pixi global shortcut add" [
    ...packages: string       # The package name to add the shortcuts from
    --environment(-e): string # The environment from which the shortcut should be added
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global shortcut add pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global shortcut add pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global shortcut add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global shortcut remove pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global shortcut remove pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global shortcut remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove shortcuts from your machine
  export extern "pixi global shortcut remove" [
    ...shortcuts: string      # The shortcut that should be removed
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global shortcut remove pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global shortcut remove pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global shortcut remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi global shortcut help" [
  ]

  # Add a shortcut from an environment to your machine.
  export extern "pixi global shortcut help add" [
  ]

  # Remove shortcuts from your machine
  export extern "pixi global shortcut help remove" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi global shortcut help help" [
  ]

  def "nu-complete pixi global update pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global update pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global update color" [] {
    [ "always" "never" "auto" ]
  }

  # Updates environments in the global environment
  export extern "pixi global update" [
    ...environments: string   # Specifies the environments that are to be updated
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global update pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global update pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global update color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global upgrade color" [] {
    [ "always" "never" "auto" ]
  }

  # Upgrade specific package which is installed globally. This command has been removed, please use `pixi global update` instead
  export extern "pixi global upgrade" [
    ...specs: string          # Specifies the packages to upgrade
    --channel(-c): string     # The channels to consider as a name or a url. Multiple channels can be specified by using this field multiple times
    --platform: string        # The platform to install the package for
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global upgrade color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global upgrade-all pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi global upgrade-all pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi global upgrade-all color" [] {
    [ "always" "never" "auto" ]
  }

  # Upgrade all globally installed packages This command has been removed, please use `pixi global update` instead
  export extern "pixi global upgrade-all" [
    --channel(-c): string     # The channels to consider as a name or a url. Multiple channels can be specified by using this field multiple times
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi global upgrade-all pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi global upgrade-all pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --platform: string        # The platform to install the package for
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global upgrade-all color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi global tree color" [] {
    [ "always" "never" "auto" ]
  }

  # Show a tree of dependencies for a specific global environment
  export extern "pixi global tree" [
    --environment(-e): string # The environment to list packages for
    regex?: string            # List only packages matching a regular expression
    --invert(-i)              # Invert tree and show what depends on a given package in the regex argument
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi global tree color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi global help" [
  ]

  # Adds dependencies to an environment
  export extern "pixi global help add" [
  ]

  # Edit the global manifest file
  export extern "pixi global help edit" [
  ]

  # Installs the defined packages in a globally accessible location and exposes their command line applications.
  export extern "pixi global help install" [
  ]

  # Uninstalls environments from the global environment.
  export extern "pixi global help uninstall" [
  ]

  # Removes dependencies from an environment
  export extern "pixi global help remove" [
  ]

  # Lists global environments with their dependencies and exposed commands. Can also display all packages within a specific global environment when using the --environment flag.
  export extern "pixi global help list" [
  ]

  # Sync global manifest with installed environments
  export extern "pixi global help sync" [
  ]

  # Interact with the exposure of binaries in the global environment
  export extern "pixi global help expose" [
  ]

  # Add exposed binaries from an environment to your global environment
  export extern "pixi global help expose add" [
  ]

  # Remove exposed binaries from the global environment
  export extern "pixi global help expose remove" [
  ]

  # Interact with the shortcuts on your machine
  export extern "pixi global help shortcut" [
  ]

  # Add a shortcut from an environment to your machine.
  export extern "pixi global help shortcut add" [
  ]

  # Remove shortcuts from your machine
  export extern "pixi global help shortcut remove" [
  ]

  # Updates environments in the global environment
  export extern "pixi global help update" [
  ]

  # Upgrade specific package which is installed globally. This command has been removed, please use `pixi global update` instead
  export extern "pixi global help upgrade" [
  ]

  # Upgrade all globally installed packages This command has been removed, please use `pixi global update` instead
  export extern "pixi global help upgrade-all" [
  ]

  # Show a tree of dependencies for a specific global environment
  export extern "pixi global help tree" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi global help help" [
  ]

  def "nu-complete pixi info color" [] {
    [ "always" "never" "auto" ]
  }

  # Information about the system, workspace and environments for the current machine
  export extern "pixi info" [
    --extended                # Show cache and environment size
    --json                    # Whether to show the output as JSON or not
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi info color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi init format" [] {
    [ "pixi" "pyproject" "mojoproject" ]
  }

  def "nu-complete pixi init scm" [] {
    [ "github" "gitlab" "codeberg" ]
  }

  def "nu-complete pixi init color" [] {
    [ "always" "never" "auto" ]
  }

  # Creates a new workspace
  export extern "pixi init" [
    path?: path               # Where to place the workspace (defaults to current path)
    --channel(-c): string     # Channel to use in the workspace
    --platform(-p): string    # Platforms that the workspace supports
    --import(-i): path        # Environment.yml file to bootstrap the workspace
    --format: string@"nu-complete pixi init format" # The manifest format to create
    --pyproject-toml          # Create a pyproject.toml manifest instead of a pixi.toml manifest
    --scm(-s): string@"nu-complete pixi init scm" # Source Control Management used for this workspace
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi init color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi import format" [] {
    [ "conda-env" "pypi-txt" ]
  }

  def "nu-complete pixi import pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi import pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi import color" [] {
    [ "always" "never" "auto" ]
  }

  # Imports a file into an environment in an existing workspace.
  export extern "pixi import" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    FILE: path                # File to import into the workspace
    --format: string@"nu-complete pixi import format" # Which format to interpret the file as
    --platform(-p): string    # The platforms for the imported environment
    --environment(-e): string # A name for the created environment
    --feature(-f): string     # A name for the created feature
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi import pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi import pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi import color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi install pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi install pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi install color" [] {
    [ "always" "never" "auto" ]
  }

  # Install an environment, both updating the lockfile and installing the environment
  export extern "pixi install" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --environment(-e): string # The environment to install
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi install pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi install pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --all(-a)                 # Install all environments
    --skip: string            # Skip installation of specific packages present in the lockfile. This uses a soft exclusion: the package will be skipped but its dependencies are installed
    --skip-with-deps: string  # Skip a package and its entire dependency subtree. This performs a hard exclusion: the package and its dependencies are not installed unless reachable from another non-skipped root
    --only: string            # Install and build only these package(s) and their dependencies. Can be passed multiple times
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi install color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi list sort_by" [] {
    [ "size" "name" "kind" ]
  }

  def "nu-complete pixi list color" [] {
    [ "always" "never" "auto" ]
  }

  # List workspace's packages
  export extern "pixi list" [
    regex?: string            # List only packages matching a regular expression
    --platform: string        # The platform to list packages for. Defaults to the current platform
    --json                    # Whether to output in json format
    --json-pretty             # Whether to output in pretty json format
    --sort-by: string@"nu-complete pixi list sort_by" # Sorting strategy
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --environment(-e): string # The environment to list packages for. Defaults to the default environment
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --no-install              # Don't modify the environment, only modify the lock-file
    --explicit(-x)            # Only list packages that are explicitly defined in the workspace
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi lock color" [] {
    [ "always" "never" "auto" ]
  }

  # Solve environment and update the lock file without installing the environments
  export extern "pixi lock" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --no-install              # Don't modify the environment, only modify the lock-file
    --json                    # Output the changes in JSON format
    --check                   # Check if any changes have been made to the lock file. If yes, exit with a non-zero code
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi lock color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi reinstall pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi reinstall pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi reinstall color" [] {
    [ "always" "never" "auto" ]
  }

  # Re-install an environment, both updating the lockfile and re-installing the environment
  export extern "pixi reinstall" [
    ...packages: string       # Specifies the package that should be reinstalled. If no package is given, the whole environment will be reinstalled
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --environment(-e): string # The environment to install
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi reinstall pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi reinstall pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --all(-a)                 # Install all environments
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi reinstall color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi remove pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi remove pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Removes dependencies from the workspace
  export extern "pixi remove" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    ...specs: string          # The dependency as names, conda MatchSpecs or PyPi requirements
    --host                    # The specified dependencies are host dependencies. Conflicts with `build` and `pypi`
    --build                   # The specified dependencies are build dependencies. Conflicts with `host` and `pypi`
    --pypi                    # The specified dependencies are pypi dependencies. Conflicts with `host` and `build`
    --platform(-p): string    # The platform for which the dependency should be modified
    --feature(-f): string     # The feature for which the dependency should be modified
    --git(-g): string         # The git url to use when adding a git dependency
    --branch: string          # The git branch
    --tag: string             # The git tag
    --rev: string             # The git revision
    --subdir(-s): string      # The subdirectory of the git repository to use
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi remove pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi remove pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi run pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi run pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi run color" [] {
    [ "always" "never" "auto" ]
  }

  
  def "nu-complete pixi run" [] {
    ^pixi info --json | from json | get environments_info | get tasks | flatten | uniq
  }

  def "nu-complete pixi run environment" [] {
    ^pixi info --json | from json | get environments_info | get name
  }

  # Runs task in the pixi environment
  export extern "pixi run" [
    ...task: string@"nu-complete pixi run"           # The pixi task or a task shell command you want to run in the workspace's environment, which can be an executable in the environment's PATH
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --as-is                   # Shorthand for the combination of --no-install and --frozen
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi run pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi run pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --force-activate          # Do not use the environment activation cache. (default: true except in experimental mode)
    --no-completions          # Do not source the autocompletion scripts from the environment
    --environment(-e): string@"nu-complete pixi run environment" # The environment to run the task in
    --clean-env               # Use a clean environment to run the task
    --skip-deps               # Don't run the dependencies of the task ('depends-on' field in the task definition)
    --dry-run(-n)             # Run the task in dry-run mode (only print the command that would run)
    --help
    -h
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi run color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  export alias "pixi r" = pixi run

  def "nu-complete pixi search color" [] {
    [ "always" "never" "auto" ]
  }

  # Search a conda package
  export extern "pixi search" [
    package: string           # Name of package to search
    --channel(-c): string     # The channels to consider as a name or a url. Multiple channels can be specified by using this field multiple times
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --platform(-p): string    # The platform to search for, defaults to current platform
    --limit(-l): string       # Limit the number of search results
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi search color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi self-update color" [] {
    [ "always" "never" "auto" ]
  }

  # Update pixi to the latest version or a specific version
  export extern "pixi self-update" [
    --version: string         # The desired version (to downgrade or upgrade to)
    --dry-run                 # Only show release notes, do not modify the binary
    --force                   # Force download the desired version when not exactly same with the current. If no desired version, always replace with the latest version
    --no-release-note         # Skip printing the release notes
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi self-update color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi shell pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi shell pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi shell change_ps1" [] {
    [ "true" "false" ]
  }

  def "nu-complete pixi shell color" [] {
    [ "always" "never" "auto" ]
  }

  # Start a shell in a pixi environment, run `exit` to leave the shell
  export extern "pixi shell" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --as-is                   # Shorthand for the combination of --no-install and --frozen
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi shell pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi shell pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --environment(-e): string # The environment to activate in the shell
    --change-ps1: string@"nu-complete pixi shell change_ps1" # Do not change the PS1 variable when starting a prompt
    --force-activate          # Do not use the environment activation cache. (default: true except in experimental mode)
    --no-completions          # Do not source the autocompletion scripts from the environment
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi shell color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi shell-hook pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi shell-hook pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi shell-hook change_ps1" [] {
    [ "true" "false" ]
  }

  def "nu-complete pixi shell-hook color" [] {
    [ "always" "never" "auto" ]
  }

  # Print the pixi environment activation script
  export extern "pixi shell-hook" [
    --shell(-s): string       # Sets the shell, options: [`bash`,  `zsh`,  `xonsh`,  `cmd`, `powershell`,  `fish`,  `nushell`]
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --as-is                   # Shorthand for the combination of --no-install and --frozen
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi shell-hook pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi shell-hook pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --force-activate          # Do not use the environment activation cache. (default: true except in experimental mode)
    --no-completions          # Do not source the autocompletion scripts from the environment
    --environment(-e): string # The environment to activate in the script
    --json                    # Emit the environment variables set by running the activation as JSON
    --change-ps1: string@"nu-complete pixi shell-hook change_ps1" # Do not change the PS1 variable when starting a prompt
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi shell-hook color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi task color" [] {
    [ "always" "never" "auto" ]
  }

  # Interact with tasks in the workspace
  export extern "pixi task" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi task color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi task add color" [] {
    [ "always" "never" "auto" ]
  }

  # Add a command to the workspace
  export extern "pixi task add" [
    name: string              # Task name
    ...COMMAND: string        # One or more commands to actually execute
    --depends-on: string      # Depends on these other commands
    --platform(-p): string    # The platform for which the task should be added
    --feature(-f): string     # The feature for which the task should be added
    --cwd: path               # The working directory relative to the root of the workspace
    --env: string             # The environment variable to set, use --env key=value multiple times for more than one variable
    --description: string     # A description of the task to be added
    --clean-env               # Isolate the task from the shell environment, and only use the pixi environment to run the task
    --arg: string             # The arguments to pass to the task
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi task add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi task remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove a command from the workspace
  export extern "pixi task remove" [
    ...names: string          # Task name to remove
    --platform(-p): string    # The platform for which the task should be removed
    --feature(-f): string     # The feature for which the task should be removed
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi task remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi task alias color" [] {
    [ "always" "never" "auto" ]
  }

  # Alias another specific command
  export extern "pixi task alias" [
    alias: string             # Alias name
    ...depends_on: string     # Depends on these tasks to execute
    --platform(-p): string    # The platform for which the alias should be added
    --description: string     # The description of the alias task
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi task alias color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi task list color" [] {
    [ "always" "never" "auto" ]
  }

  # List all tasks in the workspace
  export extern "pixi task list" [
    --summary(-s)             # Tasks available for this machine per environment
    --machine-readable        # Output the list of tasks from all environments in machine readable format (space delimited) this output is used for autocomplete by `pixi run`
    --environment(-e): string # The environment the list should be generated for. If not specified, the default environment is used
    --json                    # List as json instead of a tree If not specified, the default environment is used
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi task list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi task help" [
  ]

  # Add a command to the workspace
  export extern "pixi task help add" [
  ]

  # Remove a command from the workspace
  export extern "pixi task help remove" [
  ]

  # Alias another specific command
  export extern "pixi task help alias" [
  ]

  # List all tasks in the workspace
  export extern "pixi task help list" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi task help help" [
  ]

  def "nu-complete pixi tree color" [] {
    [ "always" "never" "auto" ]
  }

  # Show a tree of workspace dependencies
  export extern "pixi tree" [
    regex?: string            # List only packages matching a regular expression
    --platform(-p): string    # The platform to list packages for. Defaults to the current platform
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --environment(-e): string # The environment to list packages for. Defaults to the default environment
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --no-install              # Don't modify the environment, only modify the lock-file
    --invert(-i)              # Invert tree and show what depends on given package in the regex argument
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi tree color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi update pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi update pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi update color" [] {
    [ "always" "never" "auto" ]
  }

  # The `update` command checks if there are newer versions of the dependencies and updates the `pixi.lock` file and environments accordingly
  export extern "pixi update" [
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi update pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi update pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --no-install              # Don't install the (solve) environments needed for pypi-dependencies solving
    --dry-run(-n)             # Don't actually write the lockfile or update any environment
    ...packages: string       # The packages to update, space separated. If no packages are provided, all packages will be updated
    --environment(-e): string # The environments to update. If none is specified, all environments are updated
    --platform(-p): string    # The platforms to update. If none is specified, all platforms are updated
    --json                    # Output the changes in JSON format
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi update color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi upgrade pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi upgrade pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi upgrade color" [] {
    [ "always" "never" "auto" ]
  }

  # Checks if there are newer versions of the dependencies and upgrades them in the lockfile and manifest file
  export extern "pixi upgrade" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi upgrade pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi upgrade pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    ...packages: string       # The packages to upgrade
    --feature(-f): string     # The feature to update
    --exclude: string         # The packages which should be excluded
    --json                    # Output the changes in JSON format
    --dry-run(-n)             # Only show the changes that would be made, without actually updating the manifest, lock file, or environment
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi upgrade color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi upload color" [] {
    [ "always" "never" "auto" ]
  }

  # Upload a conda package
  export extern "pixi upload" [
    host: string              # The host + channel to upload to
    package_file: path        # The file to upload
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi upload color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace color" [] {
    [ "always" "never" "auto" ]
  }

  # Modify the workspace configuration file through the command line
  export extern "pixi workspace" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace channel color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage workspace channels
  export extern "pixi workspace channel" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace channel color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace channel add pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi workspace channel add pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi workspace channel add color" [] {
    [ "always" "never" "auto" ]
  }

  # Adds a channel to the manifest and updates the lockfile
  export extern "pixi workspace channel add" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    ...channel: string        # The channel name or URL
    --priority: string        # Specify the channel priority
    --prepend                 # Add the channel(s) to the beginning of the channels list, making them the highest priority
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi workspace channel add pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi workspace channel add pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --feature(-f): string     # The name of the feature to modify
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace channel add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace channel list color" [] {
    [ "always" "never" "auto" ]
  }

  # List the channels in the manifest
  export extern "pixi workspace channel list" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --urls                    # Whether to display the channel's names or urls
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace channel list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace channel remove pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi workspace channel remove pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi workspace channel remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove channel(s) from the manifest and updates the lockfile
  export extern "pixi workspace channel remove" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    ...channel: string        # The channel name or URL
    --priority: string        # Specify the channel priority
    --prepend                 # Add the channel(s) to the beginning of the channels list, making them the highest priority
    --no-install              # Don't modify the environment, only modify the lock-file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi workspace channel remove pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi workspace channel remove pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --feature(-f): string     # The name of the feature to modify
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace channel remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace channel help" [
  ]

  # Adds a channel to the manifest and updates the lockfile
  export extern "pixi workspace channel help add" [
  ]

  # List the channels in the manifest
  export extern "pixi workspace channel help list" [
  ]

  # Remove channel(s) from the manifest and updates the lockfile
  export extern "pixi workspace channel help remove" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace channel help help" [
  ]

  def "nu-complete pixi workspace description color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage workspace description
  export extern "pixi workspace description" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace description color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace description get color" [] {
    [ "always" "never" "auto" ]
  }

  # Get the workspace description
  export extern "pixi workspace description get" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace description get color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace description set color" [] {
    [ "always" "never" "auto" ]
  }

  # Set the workspace description
  export extern "pixi workspace description set" [
    description: string       # The workspace description
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace description set color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace description help" [
  ]

  # Get the workspace description
  export extern "pixi workspace description help get" [
  ]

  # Set the workspace description
  export extern "pixi workspace description help set" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace description help help" [
  ]

  def "nu-complete pixi workspace platform color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage workspace platforms
  export extern "pixi workspace platform" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace platform color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace platform add color" [] {
    [ "always" "never" "auto" ]
  }

  # Adds a platform(s) to the workspace file and updates the lockfile
  export extern "pixi workspace platform add" [
    ...platform: string       # The platform name(s) to add
    --no-install              # Don't update the environment, only add changed packages to the lock-file
    --feature(-f): string     # The name of the feature to add the platform to
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace platform add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace platform list color" [] {
    [ "always" "never" "auto" ]
  }

  # List the platforms in the workspace file
  export extern "pixi workspace platform list" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace platform list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace platform remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove platform(s) from the workspace file and updates the lockfile
  export extern "pixi workspace platform remove" [
    ...platforms: string      # The platform name to remove
    --no-install              # Don't update the environment, only remove the platform(s) from the lock-file
    --feature(-f): string     # The name of the feature to remove the platform from
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace platform remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace platform help" [
  ]

  # Adds a platform(s) to the workspace file and updates the lockfile
  export extern "pixi workspace platform help add" [
  ]

  # List the platforms in the workspace file
  export extern "pixi workspace platform help list" [
  ]

  # Remove platform(s) from the workspace file and updates the lockfile
  export extern "pixi workspace platform help remove" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace platform help help" [
  ]

  def "nu-complete pixi workspace version color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage workspace version
  export extern "pixi workspace version" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace version color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace version get color" [] {
    [ "always" "never" "auto" ]
  }

  # Get the workspace version
  export extern "pixi workspace version get" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace version get color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace version set color" [] {
    [ "always" "never" "auto" ]
  }

  # Set the workspace version
  export extern "pixi workspace version set" [
    version: string           # The new workspace version
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace version set color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace version major color" [] {
    [ "always" "never" "auto" ]
  }

  # Bump the workspace version to MAJOR
  export extern "pixi workspace version major" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace version major color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace version minor color" [] {
    [ "always" "never" "auto" ]
  }

  # Bump the workspace version to MINOR
  export extern "pixi workspace version minor" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace version minor color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace version patch color" [] {
    [ "always" "never" "auto" ]
  }

  # Bump the workspace version to PATCH
  export extern "pixi workspace version patch" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace version patch color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace version help" [
  ]

  # Get the workspace version
  export extern "pixi workspace version help get" [
  ]

  # Set the workspace version
  export extern "pixi workspace version help set" [
  ]

  # Bump the workspace version to MAJOR
  export extern "pixi workspace version help major" [
  ]

  # Bump the workspace version to MINOR
  export extern "pixi workspace version help minor" [
  ]

  # Bump the workspace version to PATCH
  export extern "pixi workspace version help patch" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace version help help" [
  ]

  def "nu-complete pixi workspace environment color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage project environments
  export extern "pixi workspace environment" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace environment color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace environment add color" [] {
    [ "always" "never" "auto" ]
  }

  # Adds an environment to the manifest file
  export extern "pixi workspace environment add" [
    name: string              # The name of the environment to add
    --feature(-f): string     # Features to add to the environment
    --solve-group: string     # The solve-group to add the environment to
    --no-default-feature      # Don't include the default feature in the environment
    --force                   # Update the manifest even if the environment already exists
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace environment add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace environment list color" [] {
    [ "always" "never" "auto" ]
  }

  # List the environments in the manifest file
  export extern "pixi workspace environment list" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace environment list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace environment remove color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove an environment from the manifest file
  export extern "pixi workspace environment remove" [
    name: string              # The name of the environment to remove
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace environment remove color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace environment help" [
  ]

  # Adds an environment to the manifest file
  export extern "pixi workspace environment help add" [
  ]

  # List the environments in the manifest file
  export extern "pixi workspace environment help list" [
  ]

  # Remove an environment from the manifest file
  export extern "pixi workspace environment help remove" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace environment help help" [
  ]

  def "nu-complete pixi workspace export color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to export workspaces to other formats
  export extern "pixi workspace export" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace export color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace export conda-explicit-spec pinning_strategy" [] {
    [ "semver" "minor" "major" "latest-up" "exact-version" "no-pin" ]
  }

  def "nu-complete pixi workspace export conda-explicit-spec pypi_keyring_provider" [] {
    [ "disabled" "subprocess" ]
  }

  def "nu-complete pixi workspace export conda-explicit-spec color" [] {
    [ "always" "never" "auto" ]
  }

  # Export workspace environment to a conda explicit specification file
  export extern "pixi workspace export conda-explicit-spec" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    output_dir: path          # Output directory for rendered explicit environment spec files
    --environment(-e): string # The environments to render. Can be repeated for multiple environments
    --platform(-p): string    # The platform to render. Can be repeated for multiple platforms. Defaults to all platforms available for selected environments
    --ignore-pypi-errors      # PyPI dependencies are not supported in the conda explicit spec file
    --ignore-source-errors    # Source dependencies are not supported in the conda explicit spec file
    --no-lockfile-update      # DEPRECATED: use `--frozen` `--no-install`. Skips lock-file updates
    --frozen                  # Install the environment as defined in the lockfile, doesn't update lockfile if it isn't up-to-date with the manifest file
    --locked                  # Check if lockfile is up-to-date before installing the environment, aborts when lockfile isn't up-to-date with the manifest file
    --no-install              # Don't modify the environment, only modify the lock-file
    --auth-file: path         # Path to the file containing the authentication token
    --concurrent-downloads: string # Max concurrent network requests, default is `50`
    --concurrent-solves: string # Max concurrent solves, default is the number of CPUs
    --pinning-strategy: string@"nu-complete pixi workspace export conda-explicit-spec pinning_strategy" # Set pinning strategy
    --pypi-keyring-provider: string@"nu-complete pixi workspace export conda-explicit-spec pypi_keyring_provider" # Specifies whether to use the keyring to look up credentials for PyPI
    --run-post-link-scripts   # Run post-link scripts (insecure)
    --tls-no-verify           # Do not verify the TLS certificate of the server
    --use-environment-activation-cache # Use environment activation cache (experimental)
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace export conda-explicit-spec color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace export conda-environment color" [] {
    [ "always" "never" "auto" ]
  }

  # Export workspace environment to a conda environment.yaml file
  export extern "pixi workspace export conda-environment" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    output_path?: path        # Explicit path to export the environment file to
    --platform(-p): string    # The platform to render the environment file for. Defaults to the current platform
    --environment(-e): string # The environment to render the environment file for. Defaults to the default environment
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace export conda-environment color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace export help" [
  ]

  # Export workspace environment to a conda explicit specification file
  export extern "pixi workspace export help conda-explicit-spec" [
  ]

  # Export workspace environment to a conda environment.yaml file
  export extern "pixi workspace export help conda-environment" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace export help help" [
  ]

  def "nu-complete pixi workspace name color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage workspace name
  export extern "pixi workspace name" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace name color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace name get color" [] {
    [ "always" "never" "auto" ]
  }

  # Get the workspace name
  export extern "pixi workspace name get" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace name get color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace name set color" [] {
    [ "always" "never" "auto" ]
  }

  # Set the workspace name
  export extern "pixi workspace name set" [
    name: string              # The workspace name, please only use lowercase letters (a-z), digits (0-9), hyphens (-), and underscores (_)
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace name set color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace name help" [
  ]

  # Get the workspace name
  export extern "pixi workspace name help get" [
  ]

  # Set the workspace name
  export extern "pixi workspace name help set" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace name help help" [
  ]

  def "nu-complete pixi workspace system-requirements color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage workspace system requirements
  export extern "pixi workspace system-requirements" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace system-requirements color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace system-requirements add requirement" [] {
    [ "linux" "cuda" "macos" "glibc" "other-libc" ]
  }

  def "nu-complete pixi workspace system-requirements add color" [] {
    [ "always" "never" "auto" ]
  }

  # Adds an environment to the manifest file
  export extern "pixi workspace system-requirements add" [
    requirement: string@"nu-complete pixi workspace system-requirements add requirement" # The name of the system requirement to add
    version: string           # The version of the requirement
    --family: string          # The Libc family, this can only be specified for requirement `other-libc`
    --feature(-f): string     # The name of the feature to modify
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace system-requirements add color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace system-requirements list color" [] {
    [ "always" "never" "auto" ]
  }

  # List the environments in the manifest file
  export extern "pixi workspace system-requirements list" [
    --json                    # List the system requirements in JSON format
    --environment(-e): string # The environment to list the system requirements for
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace system-requirements list color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace system-requirements help" [
  ]

  # Adds an environment to the manifest file
  export extern "pixi workspace system-requirements help add" [
  ]

  # List the environments in the manifest file
  export extern "pixi workspace system-requirements help list" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace system-requirements help help" [
  ]

  def "nu-complete pixi workspace requires-pixi color" [] {
    [ "always" "never" "auto" ]
  }

  # Commands to manage the pixi minimum version requirement
  export extern "pixi workspace requires-pixi" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace requires-pixi color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace requires-pixi get color" [] {
    [ "always" "never" "auto" ]
  }

  # Get the pixi minimum version requirement
  export extern "pixi workspace requires-pixi get" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace requires-pixi get color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace requires-pixi set color" [] {
    [ "always" "never" "auto" ]
  }

  # Set the pixi minimum version requirement
  export extern "pixi workspace requires-pixi set" [
    version: string           # The required pixi version
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace requires-pixi set color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace requires-pixi unset color" [] {
    [ "always" "never" "auto" ]
  }

  # Remove the pixi minimum version requirement
  export extern "pixi workspace requires-pixi unset" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace requires-pixi unset color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  def "nu-complete pixi workspace requires-pixi verify color" [] {
    [ "always" "never" "auto" ]
  }

  # Verify the pixi minimum version requirement
  export extern "pixi workspace requires-pixi verify" [
    --manifest-path: path     # The path to `pixi.toml`, `pyproject.toml`, or the workspace directory
    --help(-h)                # Display help information
    --verbose(-v)             # Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for trace)
    --quiet(-q)               # Decrease logging verbosity (quiet mode)
    --color: string@"nu-complete pixi workspace requires-pixi verify color" # Whether the log needs to be colored
    --no-progress             # Hide all progress bars, always turned on if stderr is not a terminal
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace requires-pixi help" [
  ]

  # Get the pixi minimum version requirement
  export extern "pixi workspace requires-pixi help get" [
  ]

  # Set the pixi minimum version requirement
  export extern "pixi workspace requires-pixi help set" [
  ]

  # Remove the pixi minimum version requirement
  export extern "pixi workspace requires-pixi help unset" [
  ]

  # Verify the pixi minimum version requirement
  export extern "pixi workspace requires-pixi help verify" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace requires-pixi help help" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace help" [
  ]

  # Commands to manage workspace channels
  export extern "pixi workspace help channel" [
  ]

  # Adds a channel to the manifest and updates the lockfile
  export extern "pixi workspace help channel add" [
  ]

  # List the channels in the manifest
  export extern "pixi workspace help channel list" [
  ]

  # Remove channel(s) from the manifest and updates the lockfile
  export extern "pixi workspace help channel remove" [
  ]

  # Commands to manage workspace description
  export extern "pixi workspace help description" [
  ]

  # Get the workspace description
  export extern "pixi workspace help description get" [
  ]

  # Set the workspace description
  export extern "pixi workspace help description set" [
  ]

  # Commands to manage workspace platforms
  export extern "pixi workspace help platform" [
  ]

  # Adds a platform(s) to the workspace file and updates the lockfile
  export extern "pixi workspace help platform add" [
  ]

  # List the platforms in the workspace file
  export extern "pixi workspace help platform list" [
  ]

  # Remove platform(s) from the workspace file and updates the lockfile
  export extern "pixi workspace help platform remove" [
  ]

  # Commands to manage workspace version
  export extern "pixi workspace help version" [
  ]

  # Get the workspace version
  export extern "pixi workspace help version get" [
  ]

  # Set the workspace version
  export extern "pixi workspace help version set" [
  ]

  # Bump the workspace version to MAJOR
  export extern "pixi workspace help version major" [
  ]

  # Bump the workspace version to MINOR
  export extern "pixi workspace help version minor" [
  ]

  # Bump the workspace version to PATCH
  export extern "pixi workspace help version patch" [
  ]

  # Commands to manage project environments
  export extern "pixi workspace help environment" [
  ]

  # Adds an environment to the manifest file
  export extern "pixi workspace help environment add" [
  ]

  # List the environments in the manifest file
  export extern "pixi workspace help environment list" [
  ]

  # Remove an environment from the manifest file
  export extern "pixi workspace help environment remove" [
  ]

  # Commands to export workspaces to other formats
  export extern "pixi workspace help export" [
  ]

  # Export workspace environment to a conda explicit specification file
  export extern "pixi workspace help export conda-explicit-spec" [
  ]

  # Export workspace environment to a conda environment.yaml file
  export extern "pixi workspace help export conda-environment" [
  ]

  # Commands to manage workspace name
  export extern "pixi workspace help name" [
  ]

  # Get the workspace name
  export extern "pixi workspace help name get" [
  ]

  # Set the workspace name
  export extern "pixi workspace help name set" [
  ]

  # Commands to manage workspace system requirements
  export extern "pixi workspace help system-requirements" [
  ]

  # Adds an environment to the manifest file
  export extern "pixi workspace help system-requirements add" [
  ]

  # List the environments in the manifest file
  export extern "pixi workspace help system-requirements list" [
  ]

  # Commands to manage the pixi minimum version requirement
  export extern "pixi workspace help requires-pixi" [
  ]

  # Get the pixi minimum version requirement
  export extern "pixi workspace help requires-pixi get" [
  ]

  # Set the pixi minimum version requirement
  export extern "pixi workspace help requires-pixi set" [
  ]

  # Remove the pixi minimum version requirement
  export extern "pixi workspace help requires-pixi unset" [
  ]

  # Verify the pixi minimum version requirement
  export extern "pixi workspace help requires-pixi verify" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi workspace help help" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi help" [
  ]

  # Adds dependencies to the workspace
  export extern "pixi help add" [
  ]

  # Login to prefix.dev or anaconda.org servers to access private channels
  export extern "pixi help auth" [
  ]

  # Store authentication information for a given host
  export extern "pixi help auth login" [
  ]

  # Remove authentication information for a given host
  export extern "pixi help auth logout" [
  ]

  # Workspace configuration
  export extern "pixi help build" [
  ]

  # Cleanup the environments
  export extern "pixi help clean" [
  ]

  # Clean the cache of your system which are touched by pixi
  export extern "pixi help clean cache" [
  ]

  # Generates a completion script for a shell
  export extern "pixi help completion" [
  ]

  # Configuration management
  export extern "pixi help config" [
  ]

  # Edit the configuration file
  export extern "pixi help config edit" [
  ]

  # List configuration values
  export extern "pixi help config list" [
  ]

  # Prepend a value to a list configuration key
  export extern "pixi help config prepend" [
  ]

  # Append a value to a list configuration key
  export extern "pixi help config append" [
  ]

  # Set a configuration value
  export extern "pixi help config set" [
  ]

  # Unset a configuration value
  export extern "pixi help config unset" [
  ]

  # Run a command and install it in a temporary environment
  export extern "pixi help exec" [
  ]

  # Subcommand for global package management actions
  export extern "pixi help global" [
  ]

  # Adds dependencies to an environment
  export extern "pixi help global add" [
  ]

  # Edit the global manifest file
  export extern "pixi help global edit" [
  ]

  # Installs the defined packages in a globally accessible location and exposes their command line applications.
  export extern "pixi help global install" [
  ]

  # Uninstalls environments from the global environment.
  export extern "pixi help global uninstall" [
  ]

  # Removes dependencies from an environment
  export extern "pixi help global remove" [
  ]

  # Lists global environments with their dependencies and exposed commands. Can also display all packages within a specific global environment when using the --environment flag.
  export extern "pixi help global list" [
  ]

  # Sync global manifest with installed environments
  export extern "pixi help global sync" [
  ]

  # Interact with the exposure of binaries in the global environment
  export extern "pixi help global expose" [
  ]

  # Add exposed binaries from an environment to your global environment
  export extern "pixi help global expose add" [
  ]

  # Remove exposed binaries from the global environment
  export extern "pixi help global expose remove" [
  ]

  # Interact with the shortcuts on your machine
  export extern "pixi help global shortcut" [
  ]

  # Add a shortcut from an environment to your machine.
  export extern "pixi help global shortcut add" [
  ]

  # Remove shortcuts from your machine
  export extern "pixi help global shortcut remove" [
  ]

  # Updates environments in the global environment
  export extern "pixi help global update" [
  ]

  # Upgrade specific package which is installed globally. This command has been removed, please use `pixi global update` instead
  export extern "pixi help global upgrade" [
  ]

  # Upgrade all globally installed packages This command has been removed, please use `pixi global update` instead
  export extern "pixi help global upgrade-all" [
  ]

  # Show a tree of dependencies for a specific global environment
  export extern "pixi help global tree" [
  ]

  # Information about the system, workspace and environments for the current machine
  export extern "pixi help info" [
  ]

  # Creates a new workspace
  export extern "pixi help init" [
  ]

  # Imports a file into an environment in an existing workspace.
  export extern "pixi help import" [
  ]

  # Install an environment, both updating the lockfile and installing the environment
  export extern "pixi help install" [
  ]

  # List workspace's packages
  export extern "pixi help list" [
  ]

  # Solve environment and update the lock file without installing the environments
  export extern "pixi help lock" [
  ]

  # Re-install an environment, both updating the lockfile and re-installing the environment
  export extern "pixi help reinstall" [
  ]

  # Removes dependencies from the workspace
  export extern "pixi help remove" [
  ]

  # Runs task in the pixi environment
  export extern "pixi help run" [
  ]

  # Search a conda package
  export extern "pixi help search" [
  ]

  # Update pixi to the latest version or a specific version
  export extern "pixi help self-update" [
  ]

  # Start a shell in a pixi environment, run `exit` to leave the shell
  export extern "pixi help shell" [
  ]

  # Print the pixi environment activation script
  export extern "pixi help shell-hook" [
  ]

  # Interact with tasks in the workspace
  export extern "pixi help task" [
  ]

  # Add a command to the workspace
  export extern "pixi help task add" [
  ]

  # Remove a command from the workspace
  export extern "pixi help task remove" [
  ]

  # Alias another specific command
  export extern "pixi help task alias" [
  ]

  # List all tasks in the workspace
  export extern "pixi help task list" [
  ]

  # Show a tree of workspace dependencies
  export extern "pixi help tree" [
  ]

  # The `update` command checks if there are newer versions of the dependencies and updates the `pixi.lock` file and environments accordingly
  export extern "pixi help update" [
  ]

  # Checks if there are newer versions of the dependencies and upgrades them in the lockfile and manifest file
  export extern "pixi help upgrade" [
  ]

  # Upload a conda package
  export extern "pixi help upload" [
  ]

  # Modify the workspace configuration file through the command line
  export extern "pixi help workspace" [
  ]

  # Commands to manage workspace channels
  export extern "pixi help workspace channel" [
  ]

  # Adds a channel to the manifest and updates the lockfile
  export extern "pixi help workspace channel add" [
  ]

  # List the channels in the manifest
  export extern "pixi help workspace channel list" [
  ]

  # Remove channel(s) from the manifest and updates the lockfile
  export extern "pixi help workspace channel remove" [
  ]

  # Commands to manage workspace description
  export extern "pixi help workspace description" [
  ]

  # Get the workspace description
  export extern "pixi help workspace description get" [
  ]

  # Set the workspace description
  export extern "pixi help workspace description set" [
  ]

  # Commands to manage workspace platforms
  export extern "pixi help workspace platform" [
  ]

  # Adds a platform(s) to the workspace file and updates the lockfile
  export extern "pixi help workspace platform add" [
  ]

  # List the platforms in the workspace file
  export extern "pixi help workspace platform list" [
  ]

  # Remove platform(s) from the workspace file and updates the lockfile
  export extern "pixi help workspace platform remove" [
  ]

  # Commands to manage workspace version
  export extern "pixi help workspace version" [
  ]

  # Get the workspace version
  export extern "pixi help workspace version get" [
  ]

  # Set the workspace version
  export extern "pixi help workspace version set" [
  ]

  # Bump the workspace version to MAJOR
  export extern "pixi help workspace version major" [
  ]

  # Bump the workspace version to MINOR
  export extern "pixi help workspace version minor" [
  ]

  # Bump the workspace version to PATCH
  export extern "pixi help workspace version patch" [
  ]

  # Commands to manage project environments
  export extern "pixi help workspace environment" [
  ]

  # Adds an environment to the manifest file
  export extern "pixi help workspace environment add" [
  ]

  # List the environments in the manifest file
  export extern "pixi help workspace environment list" [
  ]

  # Remove an environment from the manifest file
  export extern "pixi help workspace environment remove" [
  ]

  # Commands to export workspaces to other formats
  export extern "pixi help workspace export" [
  ]

  # Export workspace environment to a conda explicit specification file
  export extern "pixi help workspace export conda-explicit-spec" [
  ]

  # Export workspace environment to a conda environment.yaml file
  export extern "pixi help workspace export conda-environment" [
  ]

  # Commands to manage workspace name
  export extern "pixi help workspace name" [
  ]

  # Get the workspace name
  export extern "pixi help workspace name get" [
  ]

  # Set the workspace name
  export extern "pixi help workspace name set" [
  ]

  # Commands to manage workspace system requirements
  export extern "pixi help workspace system-requirements" [
  ]

  # Adds an environment to the manifest file
  export extern "pixi help workspace system-requirements add" [
  ]

  # List the environments in the manifest file
  export extern "pixi help workspace system-requirements list" [
  ]

  # Commands to manage the pixi minimum version requirement
  export extern "pixi help workspace requires-pixi" [
  ]

  # Get the pixi minimum version requirement
  export extern "pixi help workspace requires-pixi get" [
  ]

  # Set the pixi minimum version requirement
  export extern "pixi help workspace requires-pixi set" [
  ]

  # Remove the pixi minimum version requirement
  export extern "pixi help workspace requires-pixi unset" [
  ]

  # Verify the pixi minimum version requirement
  export extern "pixi help workspace requires-pixi verify" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pixi help help" [
  ]

}

export use completions *
