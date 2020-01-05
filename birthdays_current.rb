#!/usr/bin/env ruby

# If folks were to give out presents on their *own* birthdays, would it make
# sense to have many friends, or few? To be a miser or give it all away?

require "json"

MANY = 100

FOLKS = (1..MANY).map { |number|
    {
        id: number,
        reciprocal: rand(5),  # "reciprocal" folks like to give back to people they got gifts from
        friendly: rand(2),    # "friendly" folks like to give to anybody
        prefer_reciprocal: true, # rand(2) == 1 ? true : false,
        presents: 10,  # They all have a little something laying around
        got_from: {},
        gave_to: {},
    }
}
FOLKS_BY_ID = {}
FOLKS.each do |person|
    # For later tracking
    person[:starting_presents] = person[:presents]
    FOLKS_BY_ID[person[:id]] = person
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

def choose_anybody(giver)
    chosen = FOLKS[rand(MANY)]
    return chosen if giver != chosen
    choose_anybody(giver)
end

def choose_previous_giver(giver)
    gave_to_me = giver[:got_from].keys
    total_weight = giver[:got_from].values.sum

    weighted_choice = rand(total_weight)
    gave_to_me.each do |maybe_lucky|
        if giver[:got_from][maybe_lucky] > weighted_choice
            return FOLKS_BY_ID[maybe_lucky] # Yup, that's who I give to
        end
        weighted_choice -= giver[:got_from][maybe_lucky] # Nope, try the next one
    end
    raise "This shouldn't happen!"

    FOLKS_BY_ID[giver[:got_from].keys.sample] # Really simple, for now
end

def give_reciprocal_gifts giver
    # Nobody ever gave me anything? Screw those guys.
    return if giver[:got_from].empty?

    how_many_gifts = [giver[:reciprocal], giver[:presents]].min
    how_many_gifts.times do
        receiver = choose_previous_giver(giver)
        give_gift(giver, receiver)
    end
end

def give_friendly_gifts giver
    how_many_gifts = [giver[:friendly], giver[:presents]].min
    how_many_gifts.times do
        receiver = choose_anybody(giver)
        give_gift(giver, receiver)
    end
end

# Give away gifts by how friendly you are or how many you have, whichever is less.
def happy_birthday(giver)
    if giver[:prefer_reciprocal]
        give_reciprocal_gifts giver
        give_friendly_gifts giver
    else
        give_friendly_gifts giver
        give_reciprocal_gifts giver
    end
end

# Have a bunch of birthdays... Everybody gets one per year.
# No deaths, that's morbid. Just constant gift-giving.
50.times do
    FOLKS.each { |giver| happy_birthday(giver) }
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
ordered_folks = FOLKS.sort_by { |person| person[:presents] }
# Don't display everything
ordered_folks.each { |person| person.delete(:got_from); person.delete(:gave_to) }

# Print it all out
print "Folks:\n#{JSON.pretty_generate(ordered_folks)}\n\n"

if(something_wrong)
    puts "But something was wrong..."
end
