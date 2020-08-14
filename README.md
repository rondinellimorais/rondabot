# Getting Started

**Rondabot** is a powerful agent that checks for vulnerabilities on the project's premises and submits pull requests with the best version.

The high-level flow looks like this:

<p align="center">
  <img src="resources/flow.svg" alt="Rondabot architecture">
</p>

# Install

> **Ruby version**
>
> Rondabot works from ruby version `>=2.5.0`.
> Make sure you are using version `2.5.0` or higher of ruby.

To get started let's create our Gemfile:

```ruby
source "https://rubygems.org"

gem "rondabot", "~> 1.0.1"
gem "dependabot-omnibus", "~> 0.111.5"
```

run:

```bash
bundle install
```

After installation! To start using Rondabot all you need is a script looks like this:

```ruby
require "rondabot"

core = Rondabot::Core.new(
  # ...
  # the parameters. See Parameters table below
  # ...
)

# start bot
core.start()
```

## Parameters

| Name | Description |
|:------|:------|
| **provider** | Source control provider **azure**, **gitlab** or **github** |
| **organization** | Name of your organization on azure devops |
| **project** | Name of your project on azure devops |
| **repository** | Name of your project to using for clone and create pull requests |
| **credentials** | A user credentials (_username_ and _password_) permission to clone e create pull requests |
| **feed_id** | Your feed id npm/yarn on azure devops. Go to Azure Devops, your project _Artifacts_ > _Connect to feed_ > _npm_ and then you can find feed id in the url looks like `https://pkgs.dev.azure.com/your organization name/you feed id to be right here/_packaging/npm-packages/npm/registry/` |
| **github_public_token** | A GitHub access token with read access to public repos. Go to your GitHub account _Settings_ > _Developer settings_ > _Personal access tokens_ and then _Generate new token_ |

## Example

```ruby
require "dependabot/omnibus"
require "rondabot"

core = Rondabot::Core.new(
  provider: "azure",
  organization: "Akatsuki",
  project: "Digital%20Channel",
  repository: "akatsuki-website",
  credentials: {
    :username => "Ronda.Bot",
    :password => "cm9uZGluZWxsaW1vcmFpcwcm9uZGFib3Q"
  },
  feed_id: "11db190-e3b1872-1e6e6e-c97f2dd-49253",
  github_public_token: "11db190e3b18721e6e6ec97f2dd49253"
)

core.start()
```

# License

MIT.