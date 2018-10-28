.PHONY: test

console:
	irb -I lib -r micro_bench

test:
	bundle exec rspec spec
