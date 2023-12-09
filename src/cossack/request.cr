module Cossack
  # Request built by Client, that can be processed by middleware and a connection.
  #
  # ```
  # request.method                  # => "POST"
  # request.uri                     # => #<URI:0x11b8ea0 @scheme="http", @host="example.org" ...>
  # request.body                    # => "payload"
  # request.headers                 # => #<HTTP::Headers ... >
  # request.options.connect_timeout # => 30
  # request.options.read_timeout    # => 30
  # ```
  class Request
    @method : String
    @uri : URI
    @headers : HTTP::Headers
    @body : BodyType
    @options : RequestOptions

    property :method, :uri, :headers, :body, :options

    def initialize(@method : String, @uri : URI, @headers : HTTP::Headers = HTTP::Headers.new, @body : BodyType = nil, @options = RequestOptions.new)
    end

    def initialize(@method : String, uri : String, @headers : HTTP::Headers = HTTP::Headers.new, @body : BodyType = nil, @options = RequestOptions.new)
      @uri = URI.parse(uri)
    end

    def initialize(@method : String, @uri : URI, headers : Hash(String, String) = {} of String => String, @body : BodyType = nil, @options = RequestOptions.new)
      @headers = HTTP::Headers.new
      headers.each { |name, value| @headers.add(name, value) }
    end

    def initialize(@method : String, uri : String, headers : Hash(String, String) = {} of String => String, @body : BodyType = nil, @options = RequestOptions.new)
      @uri = URI.parse(uri)
      @headers = HTTP::Headers.new
      headers.each { |name, value| @headers.add(name, value) }
    end


    def to_s
     str =  method + " " + uri.to_s
     str += " with " + headers.to_s unless headers.empty?
     str += " with body: " + body.to_s unless body.nil?
     str
    end

    def inspect
      to_s
    end
  end
end
