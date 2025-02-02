require "../../spec_helper"

Spectator.describe Cossack::TestConnection do
  let(request_headers) { HTTP::Headers{ "User-Agent" => "test" } }
  let(request_method) { "GET" }
  let(request_body) { nil }
  let(request) { Cossack::Request.new(request_method, URI.parse("http://localhost/ping"), request_headers, request_body) }
  let(connection) { Cossack::TestConnection.new }

  describe "#stub_get" do
    let(request_method) { "GET" }

    describe "connectioning by URL" do
      context "when URL matches" do
        let(request_headers) { HTTP::Headers.new }

        it "returns response without headers" do
          connection.stub_get("http://localhost/ping", {200, "pong"})

          response = connection.call(request)
          expect(response.status).to eq 200
          expect(response.body).to eq "pong"
        end

        it "returns response with headers" do
          connection.stub_get("http://localhost/ping", {200, {"Content-Length" => "4"}, "pong"})

          response = connection.call(request)
          expect(response.status).to eq 200
          expect(response.body).to eq "pong"
          expect(response.headers["Content-Length"]).to eq "4"
        end
      end

      context "when URL does not match" do
        it "raises exception" do
          connection.stub_get("http://localhost/call", {200, "away"})
          expect { connection.call(request) }.to raise_error(Cossack::NoStubError)
        end
      end
    end

    describe "connectioning by URL and headers" do
      context "when URL and headers match" do
        let(request_headers) { { "User-Agent" => "Firefox" } }

        it "returns response without headers" do
          connection.stub_get("http://localhost/ping", request_headers, {500, "pong"})

          response = connection.call(request)
          expect(response.status).to eq 500
          expect(response.body).to eq "pong"
        end

        it "returns response with headers" do
          connection.stub_get("http://localhost/ping", request_headers, {200, {"Content-Length" => "4"}, "pong"})

          response = connection.call(request)
          expect(response.status).to eq 200
          expect(response.body).to eq "pong"
          expect(response.headers["Content-Length"]).to eq "4"
        end
      end

      context "when headers do not match" do
        let(fake_headers) { { "User-Agent" => "oops" } }

        it "raises exception" do
          connection.stub_get("http://localhost/ping", fake_headers, {200, {"Content-Length" => "4"}, "pong"})
          expect { connection.call(request) }.to raise_error(Cossack::NoStubError)
        end
      end
    end
  end

  describe "#stub_delete" do
    let(request_method) { "DELETE" }
    let(request_headers) { HTTP::Headers.new }

    it "returns stubbed response" do
      connection.stub_delete("http://localhost/ping", {200, "pong"})

      response = connection.call(request)
      expect(response.status).to eq 200
      expect(response.body).to eq "pong"
    end
  end

  describe "#stub_head" do
    let(request_method) { "HEAD" }
    let(request_headers) { HTTP::Headers.new }

    it "returns stubbed response" do
      connection.stub_head("http://localhost/ping", {200, "pong"})

      response = connection.call(request)
      expect(response.status).to eq 200
      expect(response.body).to eq "pong"
    end
  end

  describe "#stub_options" do
    let(request_method) { "OPTIONS" }
    let(request_headers) { HTTP::Headers.new }

    it "returns stubbed response" do
      connection.stub_options("http://localhost/ping", {200, "pong"})

      response = connection.call(request)
      expect(response.status).to eq 200
      expect(response.body).to eq "pong"
    end
  end

  describe "#stub_post" do
    let(request_method) { "POST" }
    let(request_headers) { HTTP::Headers.new }

    it "returns stubbed response" do
      connection.stub_post("http://localhost/ping", {200, "pong"})

      response = connection.call(request)
      expect(response.status).to eq 200
      expect(response.body).to eq "pong"
    end

    context "when body request specified" do
      let(request_body) { "REQUEST_BODY" }

      context "when body matches" do
        it "returns response" do
          connection.stub_post("http://localhost/ping", request_body, {200, "pong"})
          response = connection.call(request)
          expect(response.status).to eq 200
          expect(response.body).to eq "pong"
        end
      end

      context "when body does not match" do
        it "raises exception" do
          connection.stub_post("http://localhost/ping", "SOMETHING", {200, "pong"})
          expect { connection.call(request) }.to raise_error(Cossack::NoStubError)
        end
      end

      context "when headers and body are specified" do
        context "when body and headers match" do
          let(request_headers) { {"User-Agent" => "Chrome"} }
          it "returns response" do
            connection.stub_post("http://localhost/ping", request_headers, "REQUEST_BODY", {200, "pong"})
            response = connection.call(request)
            expect(response.status).to eq 200
            expect(response.body).to eq "pong"
          end
        end

        context "when headers do not match" do
          let(fake_headers) { {"User-Agent" => "Chrome"} }
          it "returns response" do
            connection.stub_post("http://localhost/ping", fake_headers, "REQUEST_BODY", {200, "pong"})
            expect { connection.call(request) }.to raise_error(Cossack::NoStubError)
          end
        end
      end

      context "when headers in response are present" do
        it "connections" do
          connection.stub_post("http://localhost/ping", "REQUEST_BODY", {204, {"Content-Type" => "application/json"}, "bang"})
          response = connection.call(request)
          expect(response.status).to eq 204
          expect(response.body).to eq "bang"
          expect(response.headers["Content-Type"]).to eq "application/json"
        end
      end
    end
  end

  describe "#stub_put" do
    let(request_method) { "PUT" }
    let(request_headers) { HTTP::Headers.new }

    it "returns stubbed response" do
      connection.stub_put("http://localhost/ping", {200, "pong"})

      response = connection.call(request)
      expect(response.status).to eq 200
      expect(response.body).to eq "pong"
    end
  end

  describe "#stub_patch" do
    let(request_method) { "PATCH" }
    let(request_headers) { HTTP::Headers.new }

    it "returns stubbed response" do
      connection.stub_patch("http://localhost/ping", {200, "pong"})

      response = connection.call(request)
      expect(response.status).to eq 200
      expect(response.body).to eq "pong"
    end
  end

  context "when request is not stubbed" do
    it "raises error" do
      expect { connection.call(request) }.to raise_error(Cossack::NoStubError)
    end
  end
end
