
# MicroBench

[![Gem Version](https://badge.fury.io/rb/micro_bench.svg)](https://badge.fury.io/rb/micro_bench)
[![CircleCI](https://circleci.com/gh/klaxit/micro_bench.svg?style=shield)](https://circleci.com/gh/klaxit/micro_bench)

```
gem install micro_bench
```

## Why ?

Ruby `Benchmark` module is nice but it uses blocks. We see 2 problems to it :
- if we want to instrument a snippet of code, it breaks git history,
- variables declared in the benchmark block cannot be used subsequently.

Let's say you want to output the duration of `method_1` from :

```ruby
foo = method_1
method_2(foo)
```

With `Benchmark`, we would write something like :
```ruby
foo = nil
duration = Benchmark.realtime do
  foo = method_1
end
puts "Method 1 duration : #{duration} seconds"
method_2(foo)
```

With `MicroBench`, it will look like this :
```ruby
MicroBench.start
foo = method_1
puts "Method 1 duration : #{MicroBench.duration} seconds"
method_2(foo)
```

## Project maturity

This has been running in production at [Klaxit](https://www.klaxit.com) for some months now, but it is still a young library. API may be subject to breaking changes on MINOR versions (but not on PATCH versions).


## Install

```
gem install micro_bench
```

or in Bundler:
```ruby
gem "micro_bench"
```

## Usage

### Basic usage

```ruby
require "micro_bench"

MicroBench.start

MicroBench.duration
# 1.628093000501394

MicroBench.duration
# 2.999483000487089

MicroBench.stop
# true

MicroBench.duration
# 5.4341670004651

MicroBench.duration
# 5.4341670004651
```

### Named benchmarks

```ruby
require "micro_bench"

MicroBench.start("timer1")

MicroBench.stop("timer1")

MicroBench.duration("timer1")
# 1.628093000501394
```

### Multiple starts

Calling `.start` multiple times with the same `bench_id` (or none) will cause a "restart" of the given benchmark.

### Thread safety

A benchmark is tied to a thread, ensuring that `MicroBench` is thread-safe. At the same time, it doesn't allow to share a benchmark between multiple threads.

### Methods isolation

A benchmark is tied to its calling method so the following code will output 2 separated durations for `method_1` and `method_2`. This prevent collisions when using `MicroBench` in a large codebase.

```ruby
def method_1
  MicroBench.start
  method_2
  # Do something
  MicroBench.stop
  puts "method_1 duration : #{MicroBench.duration}"
end

def method_2
  MicroBench.start
  # Do something
  MicroBench.stop
  puts "method_2 duration : #{MicroBench.duration}"
end

method_1
```

### Configuration

You can configure a bit `MicroBench` to have an even simpler time using it afterwards. Here's how:

```ruby
MicroBench.configure do |config|
  config.formatter = ->(duration) { "#{duration.round} seconds" }
end

MicroBench.start
sleep 2
MicroBench.duration == "2 seconds"
```

There are some default formatters that you can set:

| id        | result                       | description                              |
| --------- | ---------------------------- | ---------------------------------------- |
| `default` | `722.327823832`              | the raw original float, for computation  |
| `simple`  | `722.33`                     | rounds to 2 digits                       |
| `mmss`    | `"12:02.328"`                | Easy to understand, lossless and compact |
| `human`   | `"12 minutes and 2 seconds"` | For humans, clutters logs                |

To use one of those, simply write `config.formatter = :simple` instead of a lambda.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/klaxit/micro_bench/tags).

While still in beta (before `1.0.0`), API may be subject to breaking changes on MINOR versions (but not on PATCH versions).

## Authors

See the list of [contributors](https://github.com/klaxit/micro_bench/contributors) who participated in this project.

## License

Please see LICENSE
