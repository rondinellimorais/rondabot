require "dotenv"
require_relative "../lib/rondabot"

puts Rondabot::VERSION

core = Rondabot::Core.new(
  provider: 'azure',
  organization: ENV["ORGANIZATION"],
  project: ENV["PROJECT"],
  repository: ENV["REPOSITORY"],
  access_token: ENV["USER_PASSWORD"],
  feed_id: ENV["FEED_ID"],
  github_token: ENV["GITHUB_ACCESS_TOKEN"]
)

# core = Rondabot::Core.new(
#   provider: 'github',
#   repository: "rondinellimorais/teste-repo-rond",
#   github_token: ENV["GITHUB_ACCESS_TOKEN"]
# )
core.start()