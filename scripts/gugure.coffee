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