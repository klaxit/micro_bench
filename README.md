
# MicroBench

[![Gem Version](https://badge.fury.io/rb/micro_bench.svg)](https://badge.fury.io/rb/micro_bench)
[![CircleCI](https://circleci.com/gh/klaxit/micro_bench.svg?style=shield)](https://circleci.com/gh/klaxit/micro_bench)

Ruby `Benchmark` module is nice but it uses blocks. We see 2 problems to it :
- if we want to instrument a snippet of code, it breaks git history,
- variables are tied to the benchmark block, so we have to initialize them outside of the benchmark block to use them subsequently.

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

**WARNING : This is still beta code and may not be suitable for production usage. While still in beta, API may be subject to breaking changes on MINOR versions (but not on PATCH versions).**

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

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/klaxit/micro_bench/tags).

While still in beta (before `1.0.0`), API may be subject to breaking changes on MINOR versions (but not on PATCH versions).

## Authors

See the list of [contributors](https://github.com/klaxit/micro_bench/contributors) who participated in this project.

## License

Please see LICENSE
