module Rondabot
  VERSION = '0.0.10'
  autoload :Option, File.join(File.dirname(__FILE__), 'module/Option')
  autoload :Core, File.join(File.dirname(__FILE__), 'module/Core')
  autoload :Version, File.join(File.dirname(__FILE__), 'module/Version')
  autoload :NpmAndYarn, File.join(File.dirname(__FILE__), 'module/NpmAndYarn')
  autoload :SourceControl, File.join(File.dirname(__FILE__), 'module/SourceControl')
  autoload :Azure, File.join(File.dirname(__FILE__), 'module/Azure')
  autoload :GitHub, File.join(File.dirname(__FILE__), 'module/GitHub')
  autoload :GitLab, File.join(File.dirname(__FILE__), 'module/GitLab')
end