module MicroBench
  class << self
    def start(bench_id = nil)
      benchmarks[benchmark_key(bench_id)] = MicroBench::Benchmark.new
      return true
    end

    def stop(bench_id = nil)
      key = benchmark_key(bench_id)
      return false unless benchmarks.key?(key)

      benchmarks[key].stop
    end

    def duration(bench_id = nil)
      benchmarks[benchmark_key(bench_id)]&.duration
    end

    private

    def benchmarks
      @benchmarks ||= {}
    end

    def benchmark_key(bench_id = nil)
      "#{Thread.current.object_id}||#{bench_id}"
    end
  end
end

require "micro_bench/benchmark"
