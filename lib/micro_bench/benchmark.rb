class MicroBench::Benchmark
  attr_reader :duration

  def initialize
    @start_time = monotonic_clock_time
  end

  def stop
    return false unless @end_time.nil?

    @end_time = monotonic_clock_time
    @duration = @end_time - @start_time

    return true
  end

  def running?
    @end_time.nil?
  end

  def to_s
    "duration : #{@duration}"
  end

  def inspect
    "<#{self.class}:0x#{object_id} " \
    "@duration=#{instance_variable_get("@duration").inspect}>"
  end

  private

  def monotonic_clock_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end
end
