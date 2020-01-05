#!/usr/bin/env ruby

# If folks were to give out presents on their *own* birthdays, would it make
# sense to have many friends, or few? To be a miser or give it all away?

# This version: yup, friendly people lose out with more ticks. That makes
# sense. The way to make it more interesting, I think, is to make sure
# there's some memory in the system - remember your friends. That can
# be next.

# Getting here took about 20 minutes.

require "json"

MANY = 10

folks = (1..MANY).map { |number|
    {
        id: number,
        friendly: rand(4) + 1,
        presents: 3,  # They all have a little something laying around
    }
}
folks.each do |person|
    # For later tracking
    person[:starting_presents] = person[:presents]
end
total_starting_presents = folks.map { |person| person[:presents] }.sum

# Have a bunch of birthdays... Everybody gets one per year.
# No deaths, that's morbid. Just constant gift-giving.
30.times do
    folks.each do |giver|
        # Give away gifts by how friendly you are or how many you have, whichever is less.
        how_many_gifts = [giver[:friendly], giver[:presents]].min
        how_many_gifts.times do
            receiver = rand(MANY)
            folks[receiver][:presents] += 1
            giver[:presents] -= 1
        end
    end
end

something_wrong = false

# Do a little reasonableness-checking at the end!
folks.each do |person|
    if person[:presents] < 0
        puts "Person #{person[:id]} has less than zero gifts!"
        something_wrong = true
    end
end

total_ending_presents = folks.map { |person| person[:presents] }.sum
if total_starting_presents != total_ending_presents
    something_wrong = true
    puts "Starting presents: #{total_starting_presents}, ending presents: #{total_ending_presents}"
end

# Pick an output order
ordered_folks = folks.sort_by { |person| person[:friendly] }

# Print it all out
print "Folks:\n#{JSON.pretty_generate(ordered_folks)}\n\n"

if(something_wrong)
    puts "But something was wrong..."
end
