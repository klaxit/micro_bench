# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "micro_bench/version"

Gem::Specification.new do |s|
  s.name        = "micro_bench"
  s.version     = MicroBench::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Cyrille Courtière"]
  s.email       = ["cyrille@klaxit.com"]
  s.homepage    = "http://github.com/klaxit/micro_bench"
  s.summary     = "Dead simple benchmarks"
  s.license     = "MIT"

  s.files = `git ls-files -- lib/*`.split("\n")
  s.files += %w(README.md)
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = "lib"

  s.add_development_dependency("byebug", "~> 9.0")
  s.add_development_dependency("rspec", "~> 3.8")
end
