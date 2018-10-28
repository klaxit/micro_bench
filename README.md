
# MicroBench

[![Gem Version](https://badge.fury.io/rb/micro_bench.svg)](https://badge.fury.io/rb/micro_bench)

Dead simple, non intrusive realtime benchmarks.

Benchmark standard library is nice but it uses blocks, which break git history.

It replaces :
```
puts Benchmark.realtime do
  sleep(1)
end
```

By :
```
MicroBench.start(:my_bench)
sleep(1)
puts MicroBench.sget(:my_bench)
```

## Install

```
gem install micro_bench
```

or in Bundler:
```
gem "micro_bench"
```

## Usage

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/klaxit/micro_bench/tags).

## Authors

See the list of [contributors](https://github.com/klaxit/micro_bench/contributors) who participated in this project.

## License

Please see LICENSE
