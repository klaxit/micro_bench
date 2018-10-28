require "spec_helper"

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
end
