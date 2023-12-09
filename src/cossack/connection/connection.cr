module Cossack
  abstract class Connection
    abstract def call(request : Request, &block : Response ->)

    def call(request : Request) : Response
      call(request) { |response| return response }
    end
  end
end
