require "../spec_helper"

Spectator.describe Cossack::Client do
  it "can be initialized" do
    Cossack::Client.new
  end

  it "has a basic_auth that works" do
    client = Cossack::Client.new(TEST_SERVER_URL) do |client|
      client.basic_auth("test", "secret")
    end
    expect(client.headers["Authorization"]).to_not be(nil)
    expect(client.headers["Authorization"]).to eq("Basic dGVzdDpzZWNyZXQ=")
  end
end
