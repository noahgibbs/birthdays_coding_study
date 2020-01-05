#!/usr/bin/env ruby

# If folks were to give out presents on their *own* birthdays, would it make
# sense to have many friends, or few? To be a miser or give it all away?

# This specific version: this now kinda-sorta works. Hard to tell if friendly folks
# get the short end of the stick, as I'd expect them to. Need more ticks and maybe
# more total gifts floating around.

require "json"

MANY = 10

folks = (1..MANY).map { |number|
    {
        id: number,
        friendly: rand(4) + 1,
        presents: 3,  # They all have a little something laying around
    }
}

# Have a bunch of birthdays... Everybody gets one per year.
# No deaths, that's morbid. Just constant gift-giving.
5.times do
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

# Print it all out
print "Folks:\n#{JSON.pretty_generate(folks)}\n\n"

if(something_wrong)
    puts "But something was wrong..."
end
