module Cossack
  # Raised by TestConnection, when HTTP request is not stubbed.
  class NoStubError < Error; end

  # A connection, that is supposed to be used in tests in order to stub HTTP requests.
  #
  # ```
  # # Create and stub connection
  # connection = Cossack::TestConnection.new
  # connection.stub_get("/hello", {200, "World!"})
  #
  # Create a client and swap the connection
  # client = Cossack::Client.new("http://example.org")
  # client.connection = connection
  #
  # # Just use client
  # response = client.get("/hello")
  # response.status # => 200
  # response.body   # => "World!"
  # ```
  class TestConnection < Connection
    getter :stubs

    def initialize
      proc = ->(hash : Hash(String, Array(Stub)), key : String) { hash[key] = [] of Stub }
      @stubs = Hash(String, Array(Stub)).new(proc)
    end

    def call(request : Request, &block : Response ->)
      stubs[request.method.upcase].each do |stub|
        yield stub.response if stub.matches?(request)
      end

      error_message = <<-MESSAGE
      Request `#{request.method} #{request.uri}` is not stubbed.
      You can stub it with the following code:\n
          connection.stub_#{request.method.downcase}("#{request.uri}", {200, {"Respcontextonse-Header" => "value"}, "Response body"})
        OR
          connection.stub_#{request.method.downcase}("#{request.uri}", {"Request-Header" => "value"}, {200, "Response body"})\n
      Where `connection` is an instance of Cossack::TestConnection.\n
      MESSAGE
      raise(Cossack::NoStubError.new(error_message))
    end

    {% for method in %w(post put patch get delete head options) %}
      def stub_{{method.id}}(url : String, response : {Int32, String})
        request = Cossack::Request.new("{{method.id.upcase}}", url)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], body: response[1])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end

      def stub_{{method.id}}(url : String, response : {Int32, Hash(String, String), String})
        request = Cossack::Request.new("{{method.id.upcase}}", url)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end

      def stub_{{method.id}}(url : String, headers : Hash(String, String), response : {Int32, String})
        request = Cossack::Request.new("{{method.id.upcase}}", url, headers: headers)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], body: response[1])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end

      def stub_{{method.id}}(url : String, headers : Hash(String, String), response : {Int32, Hash(String, String), String})
        request = Cossack::Request.new("{{method.id.upcase}}", url, headers: headers)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end
    {% end %}

    {% for method in %w(post put patch) %}
      def stub_{{method.id}}(url : String, body : String, response : {Int32, String})
        request = Cossack::Request.new("{{method.id.upcase}}", url, body: body)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], body: response[1])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end

      def stub_{{method.id}}(url : String, headers : Hash(String, String), body : String, response : {Int32, String})
        request = Cossack::Request.new("{{method.id.upcase}}", url, headers, body)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], body: response[1])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end

      def stub_{{method.id}}(url : String, body : String, response : {Int32, Hash(String, String), String})
        request = Cossack::Request.new("{{method.id.upcase}}", url, body: body)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end

      def stub_{{method.id}}(url : String, headers : Hash(String, String), body : String, response : {Int32, Hash(String, String), String})
        request = Cossack::Request.new("{{method.id.upcase}}", url, headers, body)
        matcher = have_same_request_as(request)
        resp = Response.new(status: response[0], headers: response[1], body: response[2])
        @stubs["{{method.id.upcase}}"] = stubs["{{method.id.upcase}}"] << Stub.new(matcher, resp)
      end
    {% end %}
  end
end
