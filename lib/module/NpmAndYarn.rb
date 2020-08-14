require "dependabot/omnibus"
require "uri"
require "net/http"
require "json"

module Rondabot
  class NpmAndYarn

    attr_accessor :dependencies

    def initialize dependencies
      @dependencies = dependencies
    end

    #
    # Faz uma requisição do serviço do npm para verificar quais
    # dependencias da lista são vulneráveis
    #
    # Retorna uma lista de 
    # {
    #   :name => "module name",
    #   :patched_versions => [Rondabot::Version],
    #   :current_version => Rondabot::Version
    # }
    def audit
      requires = {}
      dependencies = {}
      self.dependencies.each do |dep|
        # create the requires object
        requires[:"#{dep.name}"] = dep.requirements.first[:requirement]

        # create the dependencies object
        dependencies[:"#{dep.name}"] = {
          :version => dep.requirements.first[:requirement]
        }
      end

      body = {
        :name => "rondabot",
        :version => "1.0.0",
        :requires => requires,
        :dependencies => dependencies
      }

      response = request(
        url: URI("https://registry.npmjs.org/-/npm/v1/security/audits"),
        body: body
      )

      audit_data = response.read_body
      
      #
      # Com a resposta do serviço monta um objeto contendo a versão atual
      # e as versões com vulnerabilidades
      #
      vulnerable_versions = []
      if audit_data != nil && audit_data.length > 0
        object = JSON.parse(audit_data)
        vulnerabilidades(object).each do |vul|
          vulnerable_versions << vulnerable_version(object["advisories"], vul)
        end
      end
      return vulnerable_versions
    end

    private

    def request(config)

      https = Net::HTTP.new(config[:url].host, config[:url].port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(config[:url])
      request["Content-Type"] = "application/json"
      request.body = config[:body].to_json

      return https.request(request)
    end

    def vulnerabilidades(obj_audit_data)
      vulnerabs = []
      actions = obj_audit_data["actions"]
      if !actions.empty?
        actions.each do |action|
          resolves = action["resolves"]
          if !resolves.empty?
            resolves.each do |r|
              vulnerabs << {:id => r["id"]}
            end
          end
        end
      end
      return vulnerabs
    end

    def vulnerable_version(advisories, vulnerability)
      depend = advisories["#{vulnerability[:id]}"]
      return {
        :name => depend["module_name"],
        :patched_versions => Rondabot::Version.make(depend["patched_versions"]),
        :current_version => Rondabot::Version.new(depend["findings"].first["version"])
      }
    end
  end
end

# dependencies = [
#   Dependabot::Dependency.new(
#     name: "minimist",
#     version: "1.2.0",
#     requirements: [{:requirement=>"1.2.0", :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
#     previous_requirements: [{:requirement=>"1.2.0", :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
#     package_manager: "npm_and_yarn"
#   ),
#   Dependabot::Dependency.new(
#     name: "date-fns",
#     version: "2.5.0",
#     requirements: [{:requirement=>"2.5.0", :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
#     previous_requirements: [{:requirement=>"2.3.0", :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
#     package_manager: "npm_and_yarn"
#   ),
#   Dependabot::Dependency.new(
#     name: "node.extend",
#     version: "1.1.6",
#     requirements: [{:requirement=>"1.1.6", :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
#     previous_requirements: [{:requirement=>"1.1.6", :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
#     package_manager: "npm_and_yarn"
#   )
# ]

# npm_and_yarn = Rondabot::NpmAndYarn.new(dependencies)
# puts npm_and_yarn.audit()