require "dotenv"
require "openssl"
require_relative "../lib/rondabot"

puts Rondabot::VERSION

################################
# AZURE
################################

# core = Rondabot::Core.new(
#   provider: 'azure',
#   organization: ENV["ORGANIZATION"],
#   project: ENV["PROJECT"],
#   repository: ENV["REPOSITORY"],
#   access_token: ENV["USER_PASSWORD"],
#   feed_id: ENV["FEED_ID"],
#   github_token: ENV["GITHUB_ACCESS_TOKEN"]
# )

# core.start()

################################
# GITHUB
################################

# core = Rondabot::Core.new(
#   provider: 'github',
#   repository: "rondinellimorais/teste-repo-rond",
#   github_token: ENV["GITHUB_ACCESS_TOKEN"]
# )

# core.start()

################################
# GITLAB
################################

# core = Rondabot::Core.new(
#   provider: 'gitlab',
#   hostname: ENV["GITLAB_HOST_NAME"],
#   repository: ENV["GITLAB_REPOSITORY"],
#   access_token: ENV["GITLAB_ACCESS_TOKEN"],
#   github_token: ENV["GITHUB_ACCESS_TOKEN"]
# )

# core.start()