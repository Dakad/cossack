require "../spec_helper"

# Writes response to Array @responses.
class TestMiddlwareWriter < Cossack::Middleware
  def initialize(@app, @responses = [] of Cossack::BodyType)
  end

  def call(request : Cossack::Request) : Cossack::Response
    app.call(request).tap do |response|
      @responses << response.body
    end
  end
end

# Does nothing
class TestMiddlewareNull < Cossack::Middleware
  def call(request : Cossack::Request) : Cossack::Response
    app.call(request)
  end
end

Spectator.describe "Middleware usage" do
  it "allows to register middleware" do
    responses = [] of Cossack::BodyType

    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.use TestMiddlwareWriter, responses
      client.use TestMiddlewareNull
    end

    client.get("/")
    expect(responses).to match_array(["root"])

    client.get("/math/add", {"a" => "4", "b" => "5"})
    expect(responses).to match_array(["root", "9"])
  end

  it "works with swapped connection" do
    responses = [] of Cossack::BodyType

    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.use TestMiddlwareWriter, responses
      client.connection = ->(req : Cossack::Request) do
        Cossack::Response.new(201, HTTP::Headers.new, "hello")
      end
      client.get("/")
      expect(responses).to match_array(["hello"])
    end
  end

  it "works with swapped connection passed as proc" do
    responses = [] of Cossack::BodyType

    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.use TestMiddlwareWriter, responses
      client.connection = ->(req : Cossack::Request) do
        Cossack::Response.new(201, HTTP::Headers.new, "hello")
      end
      client.get("/")
      expect(responses).to match_array(["hello"])
    end
  end
end
