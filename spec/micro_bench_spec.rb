# frozen_string_literal: true

describe MicroBench do
  it "gives seconds duration doing something" do
    described_class.start
    sleep(0.01)
    expect(
      described_class.duration.round(2)
    ).to eq(0.01)
  end

  it "allows to stop benchmark" do
    described_class.start
    sleep(0.01)
    described_class.stop
    sleep(0.02)
    expect(
      described_class.duration.round(2)
    ).to eq(0.01)
  end

  it "restart each time 'start' is called" do
    described_class.start
    sleep(0.02)
    described_class.start
    sleep(0.01)
    expect(
      described_class.duration.round(2)
    ).to eq(0.01)
  end

  it "allows multiple parallel named benchmarks" do
    described_class.start(:bench1)
    described_class.start(:bench2)
    sleep(0.01)
    described_class.stop(:bench1)
    sleep(0.01)
    described_class.stop(:bench2)
    expect(
      described_class.duration(:bench1).round(2)
    ).to eq(0.01)
    expect(
      described_class.duration(:bench2).round(2)
    ).to eq(0.01 * 2)
  end

  it "is thread safe" do
    t1 = Thread.new do
      described_class.start
      sleep(0.01)
      described_class.stop
      Thread.current[:expected] = 0.01
      Thread.current[:duration] = described_class.duration
    end
    t2 = Thread.new do
      described_class.start
      sleep(0.01 * 2)
      described_class.stop
      Thread.current[:expected] = 0.01 * 2
      Thread.current[:duration] = described_class.duration
    end

    [t1, t2].each do |t|
      t.join
      expect(t[:duration].round(2)).to eq(t[:expected])
    end
  end

  it "prevents cross-method collisions" do
    test_klass = Class.new do
      attr_accessor :method_1_duration
      attr_accessor :method_2_duration
      def method_1
        MicroBench.start
        method_2
        sleep(0.01)
        MicroBench.stop
        @method_1_duration = MicroBench.duration
      end
      def method_2
        MicroBench.start
        sleep(0.01)
        MicroBench.stop
        @method_2_duration = MicroBench.duration
      end
    end

    subject = test_klass.new
    subject.method_1
    expect(subject.method_1_duration).to_not eq(subject.method_2_duration)
  end

  it "allows referencing a benchmark from a Proc / Block / Lambda" do
    described_class.start
    # from a Proc
    proc = Proc.new do
      expect(described_class.duration).to_not be_nil
    end
    proc.call
    # from a Block
    def my_method
      yield
    end
    my_method do
      expect(described_class.duration).to_not be_nil
    end
    # from a Lambda
    l = lambda do
      expect(described_class.duration).to_not be_nil
    end
    l.call
  end

  it "formats duration when configured with an id" do
    described_class.configure do |config|
      config.formatter = :human
    end
    described_class.start
    expect(described_class.duration).to eq "0 seconds"
  end

  it "formats duration when using a callable" do
    described_class.configure do |config|
      config.formatter = proc { "result" }
    end
    described_class.start
    expect(described_class.duration).to eq "result"
  end
end
