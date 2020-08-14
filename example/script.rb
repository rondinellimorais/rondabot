require "dotenv"
require_relative "../lib/rondabot"

puts Rondabot::VERSION

core = Rondabot::Core.new(
  provider: 'azure',
  organization: ENV["ORGANIZATION"],
  project: ENV["PROJECT"],
  repository: ENV["REPOSITORY"],
  credentials: {
    :username => ENV["USERNAME"],
    :password => ENV["USER_PASSWORD"]
  },
  feed_id: ENV["FEED_ID"],
  github_public_token: ENV["GITHUB_ACCESS_TOKEN"]
)

# start bot
core.start()