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
