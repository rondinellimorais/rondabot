require_relative 'lib/rondabot'

Gem::Specification.new do |spec|
  spec.name          = "rondabot"
  spec.version       = Rondabot::VERSION
  spec.authors       = ["Rondinelli Morais"]
  spec.email         = ["rondinellimorais@gmail.com"]

  spec.summary       = %q{Rondabot searches for and fixes dependencies with security vulnerabilities.}
  spec.description   = %q{Rondabot Rondabot is a powerful agent that checks for vulnerabilities on the project's premises and submits pull requests with the best version.}
  spec.homepage      = "https://github.com/rondinellimorais/rondabot"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">=2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files         = Dir['lib/**/*.rb', 'lib/rondabot.rb', 'LICENSE', 'README.md']
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake",    "~> 11"
  spec.add_development_dependency "rspec",   "~> 3"
end
