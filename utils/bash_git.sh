  # Delightful git commands
  GIT_REPO=$(git rev-parse --show-toplevel)
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  GIT_HASH=$(git rev-parse HEAD)
  GIT_SHORT_HASH=$(git rev-parse --short HEAD)

  # Grab the git version
  if ! git describe --tags --abbrev=0 --match "v[0-9]*" > /dev/null 2>&1; then
    GIT_VERSION=$(git describe --tags --abbrev=0 --match "v[0-9]*")
  else
    GIT_VERSION="v0.0.0"
  fi

  # Grab the git-describe long version - <tag>-<#commits>-g<hash>
  # e.g. v1.0.1-1-g91ff3f3
  if ! git describe --dirty --tags --long > /dev/null 2>&1; then
    GIT_DESCRIBE=$(git describe --dirty --tags --long)
  else
    GIT_DESCRIBE="-"
  fi