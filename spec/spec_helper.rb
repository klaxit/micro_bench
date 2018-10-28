$LOAD_PATH.unshift File.join(__dir__, "..", "lib")

require "bundler/setup"
require "byebug"
require "micro_bench"

RSpec.configure do |config|
  # Config goes here
end
