Twit = require('twit')

module.exports = (robot) ->

  T = new Twit(
    consumer_key:         process.env.HUBOT_TWITTER_API_KEY
    consumer_secret:      process.env.HUBOT_TWITTER_API_SECRET
    access_token:         process.env.HUBOT_TWITTER_TOKEN
    access_token_secret:  process.env.HUBOT_TWITTER_TOKEN_SECRET
  )

  search_twitter = (msg, q, cb) ->
    T.get 'search/tweets', q: q ,include_entities: true, count: 50, (err, data, response) ->
      tweet = msg.random data.statuses
      msg.send cb(tweet)

  robot.hear /^twimg (.+)/, (msg) ->
    q = msg.match[1]
    search_twitter msg, "filter:images #{q.trim()}", (tweet) -> tweet.entities.media[0].media_url

  robot.hear /^(ぞい|zoi)/, (msg) ->
    msg.send "antibot zoi"

  robot.respond /naoya/, (msg) ->
    msg.http('http://mcg.herokuapp.com/e3e01cbc0bfcc637bf4d734cbea7d795/json')
      .get() (err, res, body) ->
        message = JSON.parse(body)
        msg.send ":naoya: " + message.result

