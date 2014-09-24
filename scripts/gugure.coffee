module.exports = (robot) ->
  robot.hear /(.+)\s?でぐぐれ/, (msg) ->
    msg
      .http("https://www.googleapis.com/customsearch/v1")
      .query
        key: process.env.HUBOT_GOOGLE_SEARCH_KEY
        cx:  process.env.HUBOT_GOOGLE_SEARCH_CX
        fields: "items(title,link)"
        num: 1
        q: msg.match[1]
      .get() (err, res, body) ->
        resp = ""
        results = JSON.parse(body)
        if results.error
          results.error.errors.forEach (err) ->
            resp += err.message
        else
          results.items.forEach (item) ->
            resp += item.title + " - " + item.link + "\n"

        msg.send resp

  robot.hear /(.+)の株くれ/, (msg) ->
    msg
      .http("https://www.googleapis.com/customsearch/v1")
      .query
        key: process.env.HUBOT_GOOGLE_SEARCH_KEY
        cx:  process.env.HUBOT_GOOGLE_SEARCH_CX
        fields: "items(title,link)"
        num: 3
        q: "#{msg.match[1]} 株価"
      .get() (err, res, body) ->
        results = JSON.parse(body)
        if results.error
          results.error.errors.forEach (err) ->
            msg.send err.message
        else
          results.items.some (item) ->
            match = item.link.match(/(\d{4})/)
            if match
              msg.send "http://chart.yahoo.co.jp/?code=#{match[1]}.T&tm=1y&type=c&log=off&size=m&over=m65,m130,s&add=v&comp="
              return true

