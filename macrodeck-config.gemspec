Gem::Specification.new do |s|
  s.name              = "macrodeck-config"
  s.version           = "0.0.1"
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Keith Gable"]
  s.email             = ["ziggy@ignition-project.com"]
  s.homepage          = "https://github.com/poseidonimaging/macrodeck-config"
  s.summary           = "The MacroDeck configuration file parser"
  s.description       = "The MacroDeck configuration file parser"

  s.required_rubygems_version = ">= 1.3.6"

  # If you have runtime dependencies, add them here
  s.add_runtime_dependency "sinatra"

  # If you have development dependencies, add them here
  s.add_development_dependency "rake"

  # The list of files to be contained in the gem
  s.files         = `git ls-files`.split("\n")
  # s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  # s.extensions    = `git ls-files ext/extconf.rb`.split("\n")
  
  s.require_path = 'lib'
end