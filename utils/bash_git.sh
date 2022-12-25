  ## Delightful git commands
  GIT_REPO=$(git rev-parse --show-toplevel 2>/dev/null || printf "-")
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf "-")
  GIT_HASH=$(git rev-parse HEAD 2>/dev/null || printf "-")
  GIT_SHORT_HASH=$(git rev-parse --short HEAD 2>/dev/null || printf "-")

  # Grab the git version. Assumes tags matching vX.X.X
  GIT_VERSION=$(git describe --tags --abbrev=0 --match "v[0-9]*" 2>/dev/null || printf "-")

  # Grab the git-describe long version - <tag>-<#commits>-g<hash>
  # e.g. v1.0.1-1-g91ff3f3
  GIT_DESCRIBE=$(git describe --dirty --tags --long > /dev/null 2>/dev/null || printf "-")