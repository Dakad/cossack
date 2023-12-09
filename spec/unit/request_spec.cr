require "../spec_helper"

Spectator.describe Cossack::Request do
  subject(request) { Cossack::Request.new("GET", URI.parse("http://localhost"), HTTP::Headers.new, "body") }

  describe "#initialize" do
    it "initializes a request" do
      expect(request.method).to eq "GET"
      expect(request.uri).to be_a URI
      expect(request.uri.to_s).to eq "http://localhost"
      expect(request.headers).to be_a HTTP::Headers
      expect(request.body).to eq "body"
    end
  end

  describe "#options" do
    it "is instance of RequestOptions" do
      expect(request.options).to be_a Cossack::RequestOptions
    end
  end
end
