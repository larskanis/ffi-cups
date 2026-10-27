require_relative 'lib/ffi-cups/version'

Gem::Specification.new do |s|
  s.name        = "ffi-cups2"
  s.version     = Cups::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hugo Marquez", "Nathan Ehresman", "Lars Kanis"]
  s.email       = ["hugomarquez.dev@gmail.com", "n_github@ehresman.org", "lars@greiz-reinsdorf.de"]
  s.homepage    = "https://github.com/larskanis/ffi-cups"
  s.summary     = "FFI wrapper around libcups2"
  s.description = "Simple wrapper around libcups to give CUPS printing capabilities to Ruby apps."
  s.license     = "MIT"
  s.required_ruby_version = Gem::Requirement.new(">= 3.2")

  s.add_runtime_dependency "ffi", "~> 1.16"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }

  s.require_paths = ["lib"]
end
