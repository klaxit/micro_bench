module MicroBench
  class << self
    def start(bench_id = nil)
      benchmarks[benchmark_key(bench_id)] = MicroBench::Benchmark.new
      return true
    end

    def stop(bench_id = nil)
      key = benchmark_key(bench_id)
      if benchmarks[key].nil?
        raise ArgumentError, "Unknown benchmark #{bench_id}"
      end

      benchmarks[key].stop
    end

    def get(bench_id = nil)
      benchmarks[benchmark_key(bench_id)]
    end

    def sget(bench_id = nil)
      stop(bench_id)
      get(bench_id)
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
