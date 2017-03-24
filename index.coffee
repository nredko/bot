fs = require 'fs'
path = require 'path'

http = require 'http'
https = require 'https'
url = require 'url'
fs = require 'fs'

URL="https://raw.githubusercontent.com/nredko/bot/master/src/testbot.coffee"
etag = {}
try 
  etag = require('./etag.json') 
catch e
# console.log e
# console.log JSON.stringify(etag, null, 2)

options = url.parse(URL)
if etag.etag?
  options.headers = {}
  options.headers['If-None-Match'] = etag.etag

module.exports = (robot, scripts) ->
  scriptsPath = path.resolve(__dirname, 'src')
  https.get options, (res) ->
    if res.statusCode = 304
      robot.loadFile(scriptsPath, script)
      return
    newtag = {etag: res.headers.etag}
    fs.writeFile '#{scriptsPath}/etag.json', JSON.stringify(newtag), (err) ->
      console.log "Can't write etag.json: "+err
    data = ''
    res.on 'data', (chunk) ->
      data += chunk.toString()
    res.on 'end', () ->
      fs.writeFileSync '#{scriptsPath}/testbot.coffee', data
      robot.loadFile(scriptsPath, script)


