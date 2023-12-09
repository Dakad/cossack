module Cossack
  class TestConnection < Connection
    class Stub
      getter :request_matcher, :response

      def initialize(@request_matcher : Spectator::Matchers::RequestMatcher, @response : Response)
      end

      def matches?(request : Request)
        @request_matcher.compare_with?(request)
      end
    end
  end
end
