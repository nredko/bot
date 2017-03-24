// Description
//   A hubot script that does the things
//
// Author:
//   Nikolay Redko <nredko@nredko.com>

module.exports = function(robot) {
  robot.respond(/hello/, function(res) {
    return res.reply("hello!");
  });
  return robot.hear(/orly/, function(res) {
    return res.send("yarly");
  });
};
