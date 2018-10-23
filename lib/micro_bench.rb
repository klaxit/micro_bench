module MicroBench
  class << self
    def start(bench_id = nil)
      lock.synchronize do
        benchmarks[bench_id] = MicroBench::Benchmark.new
        return bench_id
      end
    end

    def stop(bench_id = nil)
      lock.synchronize do
        if benchmarks[bench_id].nil?
          raise ArgumentError, "Unknown benchmark #{bench_id}"
        end
        benchmarks[bench_id].stop
      end
    end

    def get(bench_id = nil)
      benchmarks[bench_id]
    end

    def sget(bench_id = nil)
      stop(bench_id)
      get(bench_id)
    end

    def lock
      @lock ||= Mutex.new
    end

    def benchmarks
      @benchmarks ||= {}
    end
  end
end

require "micro_bench/benchmark"
