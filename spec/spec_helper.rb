require "minitest/spec"
require "minitest/pride"
require "minitest/autorun"

require_relative '../lib/town_crier'

Ohm.connect :db => 15

unless Ohm.redis.keys('*').length < 1
  raise "**** Redis db 15 has data! Abort! ****"
end

MiniTest::Spec.after do
  Ohm.redis.flushdb
end

class MiniTest::Spec < MiniTest::Unit::TestCase
  def with_temp_class(name, &block)
    raise "Must provide a block" unless block_given?
    raise("Cannot define temp class, constant #{name} is already defined") if Object.const_defined?(name)
    Object.const_set name, Class.new
    yield
    Object.send(:remove_const, name)
  end
end
