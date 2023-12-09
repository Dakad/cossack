require "../spec_helper.cr"

Spectator.describe Spectator::Matchers::RequestMatcher do
  let(request_headers) { HTTP::Headers{ "User-Agent" => "Cossack"} }
  let(request) { Cossack::Request.new("POST", URI.parse("https://httpbin.org/post"), request_headers, "Yello World") }

  let(matcher) { Cossack::Request.new(method, url, headers, body) }
  let(method) { "" }
  let(url) { "" }
  let(headers) { HTTP::Headers.new }
  let(body) { nil }

  describe "#matches?" do

    context "when nothing is specified" do
      it "returns false" do
        expect(matcher).to_not have_same_request_as(request)
      end
    end

    context "when method is specified" do
      context "and method does not match" do
        let(method) { "GET" }
        it "returns false" { expect(matcher).to_not have_same_request_as(request) }
      end

      context "when method matches" do
        let(method) { "POST" }

        context "when URL is specified" do
          context "and URL does not match" do
            let(url) { "https://httpbin.org/uuid" }
            it "returns false" { expect(matcher).to_not have_same_request_as(request) }

            context "and only path is specified" do
              let(url) { "/other/path" }
              it "returns false" { expect(matcher).to_not have_same_request_as(request) }
            end

            context "when path and query are specified" do
              let(url) { "/post?q=term" }
              it "returns false" { expect(matcher).to_not have_same_request_as(request) }
            end

            context "when scheme does not match" do
              let(url) { "http://httpbin.org/post" }
              it "returns false" { expect(matcher).to_not have_same_request_as(request) }
            end
          end

          context "when URL matches" do
              let(url) { "https://httpbin.org/post" }

            context "and only path is specified" do
              let(url) { "/post" }
              it "returns false" { expect(matcher).to_not have_same_request_as(request) }
            end

            context "when headers are given" do
              context "and one of headers do not match" do
                let(headers) { HTTP::Headers{"User-Agent" => "Firefox"} }
                it "returns false" { expect(matcher).to_not have_same_request_as(request) }
              end

              context "when all headers match" do
                let(headers) { HTTP::Headers{"User-Agent" => "Cossack"} }

                context "when body is specified" do
                  context "and body does not match" do
                    let(body) { "Bye bye" }
                    it "returns false" { expect(matcher).to_not have_same_request_as(request) }
                  end

                  context "when body matches" do
                    let(body) { "Yello World" }

                    it "returns true" do
                      expect(matcher).to have_same_request_as(request)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
