module Rondabot
  class GitLab < SourceControl
    def initialize params
      super(params)
    end

    def repository_uri
      raise "not implemented"
    end
  end
end