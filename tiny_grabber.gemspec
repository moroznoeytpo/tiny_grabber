# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tiny_grabber/version'

Gem::Specification.new do |spec|
  spec.name          = "tiny_grabber"
  spec.version       = TinyGrabber::VERSION
  spec.authors       = ["Aleksandr Chernyshev"]
  spec.email         = ["moroznoeytpo@gmail.com"]

  spec.summary       = %q{Tiny grabber}
  spec.description   = %q{Simple gem for grabbing remote web page.}
  spec.homepage      = "https://github.com/moroznoeytpo/tiny_grabber"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "https://rubygems.org/gems/tiny_grabber"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "socksify", '~> 1.7'
  spec.add_dependency "nokogiri", '~> 1.6'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
