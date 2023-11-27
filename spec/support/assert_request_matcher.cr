require "spectator"

module Spectator::Matchers
  struct RequestMatcher < Spectator::Matchers::ValueMatcher(Cossack::Request)
    # Describes what this matcher does.
    def description : String
      "is a request matcher"
    end

    def expected_request
      expected.value
    end

    # This method defines what satisfies the matcher.
    def match?(actual : Spectator::Expression(T)) : Bool forall T
      compare_with? actual.value
    end

    def compare_with?(actual_request : T) : Bool forall T
      return false if actual_request.method != expected_request.method
      return false if actual_request.uri != expected_request.uri
      return false if actual_request.body != expected_request.body
      return false if actual_request.headers != expected_request.headers

      {% for uri_part in %w(scheme host port user password path query) %}
        return false if actual_request.uri.{{uri_part.id}} && actual_request.uri.{{uri_part.id}} != expected_request.uri.{{uri_part.id}}
      {% end %}

      true
    end

    # This method generates a string explaining
    # why the actual value didn't satisfy the matcher.
    private def failure_message(actual : Spectator::Expression(T)) : String forall T
      # You will almost always want to use the labels instead of the values here.
      "#{actual.label} is not the same request as #{expected.label}"
    end

    private def failure_message_when_negated(actual : Spectator::Expression(T)) : String forall T
      "#{actual.label} should not be the same request as #{expected.label}"
    end
  end
end

macro have_same_request_as(expected)
  %test_value = ::Spectator::Value.new({{expected}}, {{expected.stringify}})
  ::Spectator::Matchers::RequestMatcher.new(%test_value)
end
