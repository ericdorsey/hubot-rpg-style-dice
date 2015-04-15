# Commands
#   $ roll {x}d{y} - hubot rolls x dice of y sides (i.e., 3D6 means 3 six sided dice)
#
# Description
#   Rolls varying number of dice

module.exports = (robot) ->
  robot.hear /\$ roll [1-9][0-9]{0,3}d[1-9][0-9]{0,3}/i, (msg) ->
    roll_request = msg.match.toString().split(" ")[2].toLowerCase()
    split_request = roll_request.split("d")
    dice_number = split_request[0]
    dice_sides = split_request[1]
    rollDice(msg, dice_number, dice_sides)

  rollOnce = (msg, sides) ->
    one_roll = Math.floor(Math.random() * sides) + 1
    return one_roll

  rollDice = (msg, dice_number, dice_sides) ->
    total = 0
    array_of_roll = []
    msg.send "Rolling #{dice_number} dice of #{dice_sides} sides"
    for i in [0...dice_number]
      current_roll = rollOnce(msg, dice_sides)
      array_of_roll.push(current_roll)
      total += current_roll
    rolled_output_string = "Rolled "
    for value, index in array_of_roll
      if index < array_of_roll.length - 1
        rolled_output_string += value + ", "
      else if value == array_of_roll[array_of_roll.length - 1]
        rolled_output_string += "and " + value
    msg.send rolled_output_string
    msg.send "Total of rolls: " + total
    return total


