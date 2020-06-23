# frozen_string_literal: true

class MicroBench::Configurations
  attr_reader :formatter

  # Initialize with a default formatters that changes nothing.
  def initialize
    @formatter = method(:default_formatter)
  end

  # Set formatter to change {MicroBench.duration} results.
  #
  # == Parameters:
  # value::
  #   It can be a proc that receives a duration float in seconds and returns any
  #   formatted value. Or it can be one of the default values, +"simple"+,
  #   +"mmss"+ or +"human"+. If you set it to +nil+ or +"default"+, the
  #   formatter will be ignored, and the result will be the raw float.
  def formatter=(value)
    # This ensures that both Proc and Method can be used there. Or even a user
    # defined class that responds to call.
    if value.respond_to?(:call)
      @formatter = value
      return
    end

    formatter_method =
      case value.to_s
      when "", "default"
        :default_formatter
      when "simple"
        :simple_formatter
      when "mmss"
        :mmss_formatter
      when "human"
        :human_formatter
      else
        raise ArgumentError, "formatter must be callable or a default string"
      end

    @formatter = method(formatter_method)
  end

  private

  def default_formatter(duration)
    duration
  end

  def simple_formatter(duration)
    duration.round(2)
  end

  def mmss_formatter(duration)
    ss, ms = duration.divmod(1)
    mm, ss = ss.divmod(60)
    hh, mm = mm.divmod(60)

    # Format ms to have only 3 digits.
    ms = (ms * 1_000).round

    return format("%02d:%02d:%02d.%03d", hh, mm, ss, ms) if hh > 0
    return format("%02d:%02d.%03d", mm, ss, ms) if mm > 0
    return format("%d.%03d", ss, ms)
  end

  def human_formatter(duration)
    ss = duration.round
    mm, ss = ss.divmod(60)
    hh, mm = mm.divmod(60)

    human_unit = ->(value, name) { "#{value} #{name}#{"s" unless value == 1}" }

    hours   = human_unit[hh, "hour"]
    minutes = human_unit[mm, "minute"]
    seconds = human_unit[ss, "second"]

    human_join = ->(*array) { array[0..-2].join(", ") + " and #{array.last}" }

    return human_join[hours, minutes, seconds] if hh > 0
    return human_join[minutes, seconds] if mm > 0
    return seconds
  end
end
