  # Delightful git commands
  GIT_REPO=$(git rev-parse --show-toplevel)
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  GIT_HASH=$(git rev-parse HEAD)
  GIT_SHORT_HASH=$(git rev-parse --short HEAD)
  # GIT_DESCRIBE=$(git describe --dirty --tags --long)