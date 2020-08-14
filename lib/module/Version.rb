# 
# Fontes de pesquisa
# 
# https://github.com/npm/node-semver
# https://github.com/jlindsey/semantic
# https://semver.org/
#
module Rondabot
  class Version
    
    SemVerRegExp = /\A(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][a-zA-Z0-9-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][a-zA-Z0-9-]*))*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?\Z/
    
    attr_accessor :major, :minor, :patch, :pre, :version

    def initialize version_str
      v = version_str.match(SemVerRegExp)

      raise ArgumentError.new("#{version_str} is not a valid SemVer Version (http://semver.org)") if v.nil?
      @major = v[1].to_i
      @minor = v[2].to_i
      @patch = v[3].to_i
      @pre = v[4]
      @build = v[5]
      @version = version_str
    end

    # Public Methods

    def gt? other_version
      compare(other_version) > 0
    end

    def lt? other_version
      compare(other_version) < 0
    end

    def eq? other_version
      compare(other_version) == 0
    end

    # Static Methods

    def self.max versions
      ordered = versions.sort_by { |s| Gem::Version.new(s.version) }
      return ordered.last
    end

    def self.min versions
      ordered = versions.sort_by { |s| Gem::Version.new(s.version) }
      return ordered.first
    end

    def self.valid str
      return str.match(SemVerRegExp)
    end

    # 
    # Cria uma lista de Version com base na string semântica
    # exemplo: 
    #   str => ">=1.1.7 <2.0.0 || >=2.0.1"
    #   vira => [Rondabot::Version[1.1.7], Rondabot::Version[2.0.0], Rondabot::Version[2.0.1]]
    # 
    def self.make str_versions
      cleared_versions = str_versions.gsub(/[^a-zA-Z0-9_\.]+/, ",").split(",")
      
      versions = []
      cleared_versions.each do |v|
        if valid(v)
          versions << Version.new(v)
        end
      end
      return versions
    end

    # 
    # A próxima versão é a mínima maior do que a atual
    #
    def self.next(current_version, patched_versions)
      biggest_versions = []
      ordered = patched_versions.sort_by { |s| Gem::Version.new(s.version) }
      ordered.each do |v|
        # Versões maiores do que a versão atual são adicionada no array
        if v.gt?(current_version.version)
          biggest_versions << v
        end
      end
      return min(biggest_versions)
    end

    # Private Methods
    private

    def compare other_version
      other_version = Version.new(other_version)
      return Gem::Version.new(self.version) <=> Gem::Version.new(other_version.version)
    end
  end
end


#
# CRIAÇÃO DO OBJETO
#
# version = Rondabot::Version.new('1.6.5')
# version.major             # => 1
# version.minor             # => 6
# version.patch             # => 5
# puts "Aqui está => #{version.patch}"


#
# TESTE DE ORDENACAO DE ARRAY
#

# array = [
#   Rondabot::Version.new('1.2.3-beta'),
#   Rondabot::Version.new('1.1.7'),
#   Rondabot::Version.new('2.0.1'),
#   Rondabot::Version.new('1.2.2-alpha'),
#   Rondabot::Version.new('0.0.54'),
#   Rondabot::Version.new('1.0.54'),
#   Rondabot::Version.new('0.79.4'),
  # Rondabot::Version.new('0.83.0'),
  # Rondabot::Version.new('0.83.1'),
#   Rondabot::Version.new('2.0.0')
# ]

# ordered = array.sort_by { |s| Gem::Version.new(s.version) }
# ordered.each do |s|
#   puts s.version
# end


#
# TESTE DE COMPARACAO
#
# version117 = Rondabot::Version.new('1.1.7')
# puts "gt? #{version117.gt?('1.1.8')}"
# puts "lt? #{version117.lt?('1.1.8')}"
# puts "eq? #{version117.eq?('1.1.8')}"


#
# MAX VERSION
#
# array = [
#   Rondabot::Version.new('1.1.7'),
#   Rondabot::Version.new('2.0.1'),
#   Rondabot::Version.new('2.0.0')
# ]

# puts Rondabot::Version::max(array).version
# puts Rondabot::Version::min(array).version

#
# CRIADOR DE VERSOES COM BASE NO PATHCED
#
# ">=1.1.7 <2.0.0 || >= 2.0.1"
#

# versions = Rondabot::Version.make(">=1.1.7 <2.0.0 || >= 2.0.1")
# puts versions
# exit

#
# METODO QUE IRÁ ACHAR A PROXIMA VERSAO COM BASE NA ATUAL
#
# versions = [
#   Rondabot::Version.new('0.83.0'),
#   Rondabot::Version.new('0.83.1'),
#   Rondabot::Version.new('1.1.7'),
#   Rondabot::Version.new('2.0.1'),
#   Rondabot::Version.new('2.0.0')
# ]
# current_version = Rondabot::Version.new('1.0.54')
# best_version_to_go = Rondabot::Version.next(current_version, versions)
# puts best_version_to_go.version