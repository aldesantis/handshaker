# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "handshaker/version"

Gem::Specification.new do |spec|
  spec.name          = "handshaker"
  spec.version       = Handshaker::VERSION
  spec.authors       = ["Alessandro Desantis"]
  spec.email         = ["desa.alessandro@gmail.com"]

  spec.summary       = "Handshaker is a Ruby gem for implementing multi-strategy Collaborative Transactional Validation"
  spec.description   = %q{CTV is a process where multiple parties cooperate to validate the integrity of a transaction.
    You can think of it as a very sophisticated `if` check, that might potentially involve tens of different conditions.
  }
  spec.homepage      = "https://github.com/batteries911/handshaker"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
