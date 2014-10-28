cheerio = require('cheerio')

module.exports = (robot) ->
  robot.hear /^(次|つぎ)の連休/, (msg) ->
    msg.http('http://japanese-long-weekends.herokuapp.com/rss')
      .get() (err, res, body) ->
        $ = cheerio.load(body)
        msg.send $("channel item title").first().text()

