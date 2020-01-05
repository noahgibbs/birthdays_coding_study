#!/usr/bin/env ruby

# If folks were to give out presents on their *own* birthdays, would it make
# sense to have many friends, or few? To be a miser or give it all away?

# Started tracking who gives gifts to whom, getting ready to make the 'friendly'
# part matter.

require "json"

MANY = 10

FOLKS = (1..MANY).map { |number|
    {
        id: number,
        reciprocal: rand(4) + 1,  # "reciprocal" folks like to give back to people they got gifts from
        friendly: rand(4) + 1,    # "friendly" folks like to give to anybody
        prefer_reciprocal: rand(2) == 1 ? true : false,
        presents: 3,  # They all have a little something laying around
        got_from: {},
        gave_to: {},
    }
}
FOLKS.each do |person|
    # For later tracking
    person[:starting_presents] = person[:presents]
end
total_starting_presents = FOLKS.map { |person| person[:presents] }.sum

def give_gift(giver, receiver)
    raise "Can't give a gift if you don't have one!" unless giver[:presents] >= 1

    receiver[:presents] += 1
    giver[:presents] -= 1

    receiver[:got_from][giver[:id]] ||= 0
    receiver[:got_from][giver[:id]] += 1
    giver[:gave_to][receiver[:id]] ||= 0
    giver[:gave_to][receiver[:id]] += 1
end

def choose_receiver(giver)
    # Old way
    return FOLKS[rand(MANY)]
end

# Have a bunch of birthdays... Everybody gets one per year.
# No deaths, that's morbid. Just constant gift-giving.
30.times do
    FOLKS.each do |giver|
        # Give away gifts by how friendly you are or how many you have, whichever is less.
        how_many_gifts = [giver[:friendly], giver[:presents]].min
        how_many_gifts.times do
            receiver = choose_receiver(giver)
            give_gift(giver, receiver)
        end
    end
end

something_wrong = false

# Do a little reasonableness-checking at the end!
FOLKS.each do |person|
    if person[:presents] < 0
        puts "Person #{person[:id]} has less than zero gifts!"
        something_wrong = true
    end
end

total_ending_presents = FOLKS.map { |person| person[:presents] }.sum
if total_starting_presents != total_ending_presents
    something_wrong = true
    puts "Starting presents: #{total_starting_presents}, ending presents: #{total_ending_presents}"
end

# Pick an output order
ordered_folks = FOLKS.sort_by { |person| person[:friendly] }

# Print it all out
print "Folks:\n#{JSON.pretty_generate(ordered_folks)}\n\n"

if(something_wrong)
    puts "But something was wrong..."
end
