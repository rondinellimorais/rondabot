require 'optparse'

module Rondabot
  class Option
    def self.parse()
      options = {}
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: example.rb [options]"

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
        
        opts.on("-ePATH", "--env=PATH", "The path to the .env file") { |v| options[:env] = v }
      end

      begin opt_parser.parse! ARGV
        rescue OptionParser::InvalidOption => e
        puts e
        puts opt_parser
        exit 1
      end

      return options
    end
  end
end