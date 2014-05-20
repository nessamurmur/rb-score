require 'json'
require 'open-uri'

module Score
  class Score
    attr_reader :score

    EVENTS = [
              "PushEvent",
              "PullRequestReviewCommentEvent",
              "WatchEvent",
              "CreateEvent",
             ]

    def initialize(json)
      @score = sum(scores(json))
    end

    def sum(scores)
      scores.reduce(:+)
    end

    def to_i
      Integer(score)
    end

    def scores(json)
      json.map { |j| score_map.fetch(j["type"], 1) }
    end

    def score_map
      {
        "PushEvent" => 5,
        "PullRequestReviewCommentEvent" => 4,
        "WatchEvent" => 3,
        "CreateEvent" => 2,
      }
    end

    def self.get_json(url="https://github.com/databyte.json")
      JSON.load(open(url))
    end
  end
end
