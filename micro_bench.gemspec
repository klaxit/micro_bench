# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "micro_bench/version"

Gem::Specification.new do |spec|
  spec.name        = "micro_bench"
  spec.version     = MicroBench::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["Cyrille Courtière"]
  spec.email       = ["dev@klaxit.com"]
  spec.homepage    = "http://github.com/klaxit/micro_bench"
  spec.summary     = "Dead simple benchmarks"
  spec.license     = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.6")

  spec.files = Dir["lib/**/*.rb"] + %w(README.md CHANGELOG.md)
  spec.test_files = Dir["spec/**/*"] + %w(.rspec)
  spec.require_paths = "lib"

  spec.add_development_dependency("byebug", "~> 9.0")
  spec.add_development_dependency("rspec", "~> 3.8")
end
