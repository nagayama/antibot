dotenv = require('dotenv')
dotenv.load()

module.exports = (robot) ->
  robot.router.post "/hubot/slack/slash-commands", (req, res) ->
    body = req.body
    if body.command == "/mayutsuba"
      payload = JSON.stringify
        channel: "#" + body.channel_name,
        username: "mayutsuba",
        text: body.text,
        icon_emoji: ":mayutsuba:"
      robot.http(process.env.SLACK_WEBHOOK_URL).post(payload)
    res.end()
