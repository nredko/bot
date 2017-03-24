# Description
#   A hubot script that does the things
#
# Author:
#   Nikolay Redko <nredko@nredko.com>

module.exports = (robot) ->
  robot.respond /hello/, (res) ->
    res.reply "hello!"

  robot.hear /orly/, (res) ->
    res.send "yarly"
