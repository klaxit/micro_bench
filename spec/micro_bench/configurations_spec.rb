# frozen_string_literal: true

describe MicroBench::Configurations do
  let(:duration) { rand(10) + rand }

  describe "#default_formatter" do
    it "does nothing" do
      expect(subject.send(:default_formatter, duration)).to eq duration
    end
  end

  describe "#simple_formatter" do
    it "rounds" do
      expect(subject.send(:simple_formatter, duration)).to eq duration.round(2)
    end
  end

  describe "#mmss_formatter" do
    it "gives hh:mm:ss.s" do
      expect(subject.send(:mmss_formatter, 457927.127)).to eq "127:12:07.127"
    end
  end

  describe "#human_formatter" do
    it "gives a text" do
      expect(subject.send(:human_formatter, 457287.4699882))
        .to eq "127 hours, 1 minute and 27 seconds"
    end
  end
end
