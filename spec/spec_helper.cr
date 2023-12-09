require "spec"
require "spectator"

require "../src/cossack"

require "./support/assert_request_matcher"
require "./support/test_connection/stub"
require "./support/test_connection"

TEST_SERVER_URL = "http://localhost:3999"

Spectator.configure do |config|
  config.fail_blank # Fail on no tests.
  config.randomize  # Randomize test order.
  config.profile    # Display slowest tests.
end
