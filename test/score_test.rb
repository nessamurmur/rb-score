require_relative '../lib/score'
require 'minitest/autorun'

module Score
  class ScoreTest < Minitest::Test
    def setup
      @score = Score.new(json_data)
    end

    def json_data
      @data ||= Array.new(10) {"type"}
        .zip(Array.new(10) { Score::EVENTS.sample })
        .map { |a| Hash[*a] }
    end

    def data_worth_fifteen
      [
       {"type" => "PushEvent"},
       {"type" => "PullRequestReviewCommentEvent"},
       {"type" => "WatchEvent"},
       {"type" => "CreateEvent"},
       {"type" => "NotAKeyInScoreMap"},
      ]
    end

    def test_json_data
      json_data.each do |h|
        assert_kind_of Hash, h
        assert h.has_key?("type")
        assert_includes Score::EVENTS, h["type"]
        assert_equal json_data, json_data
      end
    end

    def test_sum
      assert_equal 10, @score.sum([5, 5])
      assert_raises(ArgumentError) { @score.sum(["not_an_integer"]) }
    end

    def test_initialize
      assert_kind_of Integer,  @score.score
    end

    def test_scores
      refute @score.scores(json_data).any? { |s| s > 5 || s < 1 }
    end

    def test_to_i
      assert_equal @score.score, @score.to_i
    end

    def test_sanity
      assert_equal 15,  Score.new(data_worth_fifteen).score
    end

    def test_other_keys_worth_one
      other_event = [{"type" => "WeDontCare"}]
      assert_equal 1, @score.scores(other_event).first
    end

    def test_class_get_json
      msg = "set ENV variable ONLINE to something truthy to run integrationt tests"
      skip(msg) unless ENV["ONLINE"]

      response = Score.get_json
      assert_kind_of Array, response
      response.each do |h|
        assert_kind_of Hash, h
        assert h.has_key?( "type" )
      end
    end
  end
end
