require 'json'

class ApiSpike
  def gist_urls
    user = Github::User.new("faun")
    user.gists.map do |gist|
      gist.url
    end
  end
end

module Github
  class User
    def initialize(username)
      @username = username
    end

    def gists
      data = ApiRequest.new(url: "/users/#{@username}/gists").fetch_json
      data.map { |item| Gist.new(item) }
    end
  end

  class Gist
    attr_accessor :url
    def initialize(attrs)
      %w[url].each do |attr|
        self.send("#{attr}=", attrs[attr])
      end
    end
  end

  class ApiRequest
    DEFAULT_HEADERS = {
      'Accept' => 'application/json',
      'Authorization' => 'token bd3565846a320d98a072ec8e726163d516470973'
    }
    BASE_URL = 'https://api.github.com'

    def initialize options={}
      @url = options.delete(:url)
    end

    def execute
      `curl -s -H "#{headers}" #{url}`
    end

    def fetch_json
      JSON.parse(execute)
    end

    def url
      BASE_URL + @url
    end

    def headers
      DEFAULT_HEADERS.map do |key, value|
        "#{key}: #{value}"
      end.join("\n")
    end
  end
end

