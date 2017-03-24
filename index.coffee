fs = require 'fs'
path = require 'path'
pjson = require './package.json'

FILENAME="bundle.js"

module.exports = (robot, scripts) ->
  unless process.env.OPBOT_SERVER?
    robot.logger.error "#{pjson.name}:: OPBOT_SERVER env variable is not configured!"
    return
  scriptsPath = path.resolve(__dirname, '.')
  try 
    etag = require("#{scriptsPath}/etag.json").etag
  catch e
    etag = 'xxx'
  robot.logger.debug "#{pjson.name}:: ETAG: #{etag}"

  robot.http(process.env.OPBOT_SERVER + "/"+ FILENAME)
    .header('If-None-Match', etag)
    .get() (err, ret, body) ->
      robot.logger.debug "#{pjson.name}:: HTTP result #{ret.statusCode}: #{ret.statusMessage}"
      if err?
        robot.logger.error err
      else if ret.statusCode == 304
        robot.logger.debug "#{pjson.name}:: File #{FILENAME} was not changed."
        robot.loadFile(scriptsPath, FILENAME)
        return
      else if ret.statusCode == 200
        robot.logger.debug "#{pjson.name}:: File #{FILENAME} was changed, loading..."
        newtag = {etag: ret.headers.etag}
        fs.writeFile "#{scriptsPath}/etag.json", JSON.stringify(newtag), (err) ->
          if err?
            robot.logger.error "#{pjson.name}:: Can't write etag.json: "+err
        fs.writeFileSync "#{scriptsPath}/#{FILENAME}", body
        robot.loadFile(scriptsPath, FILENAME)


