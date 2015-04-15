# Commands
#   $ roll {x}d{y}{[+,-,*,/]num} - rolls x dice of y sides (i.e., 3d6 means 3 six sided dice. 3d6+2 is 3 six sided dice, then add 2)
#
# Description
#   Rolls varying number of dice in RPG style. Optional modifier.

operators = ["+", "-", "*", "/"]

module.exports = (robot) ->
  robot.hear /(\$ roll [1-9][0-9]{0,3}d[1-9][0-9]{0,3})([\+\-\*\/][1-9]{0,3}[0-9]{0,3})?/i, (msg) ->
    roll_request = msg.match[0].toString()
    split_request = roll_request.split(" ")
    total_roll = split_request[2]
    modifier_found = false
    for i in operators
      if total_roll.indexOf(i) != -1
        # found special character
        split_character = operators[operators.indexOf(i)] # which operator {+, -, *, /}
        modifier = total_roll.split(split_character)[1]
        base_roll = total_roll.split(split_character)[0]
        modifier_found = true
        # no need to keep checking
        break
    if modifier_found is false
      modifier = 0
      base_roll = total_roll

    split_request = base_roll.split("d")
    dice_number = split_request[0]
    dice_sides = split_request[1]

    rollDice(msg, dice_number, dice_sides, modifier, modifier_found, split_character)

  rollOnce = (msg, sides) ->
    one_roll = Math.floor(Math.random() * sides) + 1
    return one_roll

  rollDice = (msg, dice_number, dice_sides, modifier, modifier_found, split_character) ->
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
    if modifier_found is true
      if split_character == "+"
        modified_total = total + parseInt(modifier)
      if split_character == "-"
        modified_total = total - parseInt(modifier)
      if split_character == "*"
        modified_total = total * parseInt(modifier)
      if split_character == "/"
        modified_total = total / parseInt(modifier)
      operator = split_character.toString()
      msg.send "Total of rolls: " + total + " " + operator + " " + modifier + " is " + modified_total
    else
      msg.send "Total of rolls: " + total
    return total


