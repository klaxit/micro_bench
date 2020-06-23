# frozen_string_literal: true

module MicroBench
  class << self
    # Configure MicroBench.
    #
    # == Example usage:
    #   MicroBench.configure do |config|
    #     config.formatter = proc { |duration| duration.ceil }
    #   end
    def configure(&block)
      block.call(configurations)
      nil
    end

    # Start a benchmark
    #
    # == Parameters:
    # bench_id::
    #   Identifier of the benchmark
    #
    # == Returns:
    # A boolean representing success
    #
    # == Example usage:
    #   MicroBench.start(:my_benchmark)
    #
    # Calling the method multiple times with the same bench_id will restart
    # the benchmark for the given bench_id.
    #
    def start(bench_id = nil)
      benchmarks[benchmark_key(bench_id)] = MicroBench::Benchmark.new
      return true
    end

    # Stop a benchmark
    #
    # == Parameters:
    # bench_id::
    #   Identifier of the benchmark
    #
    # == Returns:
    # A boolean representing success
    #
    # == Example usage:
    #   MicroBench.stop(:my_benchmark)
    #
    def stop(bench_id = nil)
      key = benchmark_key(bench_id)
      return false unless benchmarks.key?(key)

      benchmarks[key].stop
    end

    # Give duration of the benchmark
    #
    # == Parameters:
    # bench_id::
    #   Identifier of the benchmark
    #
    # == Returns:
    # Duration of the given benchmark, or nil if benchmark is unknown
    #
    # == Example usage:
    #   MicroBench.stop(:my_benchmark)
    #
    def duration(bench_id = nil)
      configurations.formatter.call(
        benchmarks[benchmark_key(bench_id)]&.duration
      )
    end

    private

    def configurations
      @configurations ||= Configurations.new
    end

    def benchmarks
      @benchmarks ||= {}
    end

    def benchmark_key(bench_id = nil)
      "#{thread_key}||#{caller_key}||#{bench_id}"
    end

    def thread_key
      Thread.current.object_id
    end

    def caller_key
      caller_location = caller_locations(2..4).detect do |loc|
        !loc.absolute_path.include?(__FILE__)
      end
      "#{caller_location.absolute_path}:#{caller_location.base_label}"
    end
  end
end

require "micro_bench/benchmark"
require "micro_bench/configurations"
