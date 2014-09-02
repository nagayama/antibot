module.exports = (robot) ->
  robot.hear /(首|くび|クビ)だ/, (msg) ->
    msg.send "https://twitter.com/masa0x80/status/2629666287"
