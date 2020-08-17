module Rondabot
  class GitHub < SourceControl
    def initialize params
      super(params)
    end

    def create_pull_request params
      pull_request = super(params)

      if pull_request.state == 'open'
        puts "  PR ##{pull_request.number} submitted"
      else
        puts "  PR already exists or an error has occurred"
      end 
    end
  end
end