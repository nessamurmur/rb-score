require 'json'
require 'open-uri'

module Score

  class Score
    attr_reader :score

    def initialize(url="https://github.com/databyte.json")
      json = JSON.load(open(url))
      @score = json.reduce(0) { |sum, j| sum + score_map.fetch(j["type"], 1) }
    end

    def to_s
      score.to_s
    end

    def score_map
      {
        "PushEvent" => 5,
        "PullRequestReviewCommentEvent" => 4,
        "WatchEvent" => 3,
        "CreateEvent" => 2,
      }
    end

  end
end
