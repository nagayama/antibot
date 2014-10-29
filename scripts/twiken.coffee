dotenv = require('dotenv')
dotenv.load()
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

  robot.hear /^(ぞい)/, (msg) ->
    msg.send "antibot zoi"

  robot.hear /^(まゆゆ|まゆつば|歳納京子)/, (msg) ->
    msg.send "https://dl.dropboxusercontent.com/u/980764/halloween_mayutsuba/mayutsuba.png"

  robot.hear /^mayutsuba\s+(.+)/, (msg) ->
    q = msg.match[1]
    msg.message.username   = "mayutsuba"
    msg.message.icon_emoji = ":mayutsuba:"
    msg.custom text:q

  robot.hear /^(H|えっち)なぞい/, (msg) ->
    list = [
      "https://pbs.twimg.com/media/BtpKHsIIMAAVBOH.jpg:large",
      "https://pbs.twimg.com/media/BzW8zUACQAEO9Ez.jpg:large",
      "https://pbs.twimg.com/media/B0WdRD4CEAEdv1X.png:large",
      "https://pbs.twimg.com/media/B0WfedGCcAEwl4B.png:large",
      "http://i.imgur.com/6grf9qK.jpg",
      "https://pbs.twimg.com/media/B0Wr2MlCQAEMLqR.jpg:large",
      "http://33.media.tumblr.com/daa079c5164d11ca37c25eb766de9de3/tumblr_ndtv1bLZ3A1qd1ozgo1_1280.jpg",
      "https://pbs.twimg.com/media/B0WkBIBCIAIfJq4.jpg:large",
      "http://htn.to/motemen",
      "https://pbs.twimg.com/media/ByM9grRCUAA5RYM.jpg"
    ]
    msg.send msg.random list

  robot.hear /^zoi(\s+(http.+))?/, (msg) ->
    url = msg.match[2]
    list = robot.brain.get("list") ? []
    if url
      msg.http(url).get() (err, res, body) ->
        if !err && res.headers["content-type"].match(/^image/)
          list.push url
          list = list.filter (x, i, self) ->
            self.indexOf(x) == i
          robot.brain.set("list", list)
    else
      msg.send msg.random list

  robot.respond /naoya/, (msg) ->
    msg.http('http://mcg.herokuapp.com/e3e01cbc0bfcc637bf4d734cbea7d795/json')
      .get() (err, res, body) ->
        message = JSON.parse(body)
        msg.send ":naoya: " + message.result


  robot.hear /^まるこふ\s+add\s+(.+)/, (msg) ->
    q = msg.match[1]
    url = "http://mcg.herokuapp.com/#{q}/json"
    msg.http(url).get() (err, res, body) ->
      message = JSON.parse(body)
      if message.result
        hash = robot.brain.get("hash")
        if hash && hash.indexOf q > -1
          hash.push(q)
          robot.brain.set("hash", hash)
        else
          hash = [q]
          robot.brain.set("hash", hash)
        msg.send "I memorized #{url}"

  robot.hear /^まるこふ$/, (msg) ->
    hash = robot.brain.get("hash")
    if hash
      hash1 = msg.random hash
      hash2 = msg.random hash
      url  = "http://mcg.herokuapp.com/#{hash1}/#{hash2}/json"
      msg.http(url).get() (err, res, body) ->
        message = JSON.parse(body)
        msg.send message.result
