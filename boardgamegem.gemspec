# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boardgamegem/version'

Gem::Specification.new do |spec|
  spec.name          = "BoardGameGem"
  spec.version       = BoardGameGem::VERSION
  spec.authors       = ["Jake Roussel"]
  spec.email         = ["jakeroussel@mac.com"]

  spec.summary       = %q{Provides a Ruby interface to the BoardGameGeek API}
  spec.homepage      = "http://www.github.com/acceptableice/boardgamegem"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  dependencies = [
    # Examples:
    [:runtime,     "nokogiri"],
    [:development, "bundler", "rake"],
  ]

  dependencies.each do |type, name, version|
    if spec.respond_to?("add_#{type}_dependency")
      spec.send("add_#{type}_dependency", name, version)
    else
      spec.add_dependency(name, version)
    end
  end
end
