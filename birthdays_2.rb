# birthdays.rb

# If folks were to give out presents on their *own* birthdays, would it make
# sense to have many friends, or few? To be a miser or give it all away?

require "json"

MANY = 10

folks = (1..MANY).map {
    {
        friendly: rand(4) + 1,
        presents: 3,  # They all have a little something laying around
    }
}

# Have a bunch of birthdays... Everybody gets one per year.
# No deaths, that's morbid. Just constant gift-giving.
100.times do
    folks.each do |giver|
        # Give away gifts by how friendly you are or how many you have, whichever is less.
        how_many_gifts = [giver[:friendly], giver[:presents]].min
        giver[:friendly].times do
            receiver = rand(MANY)
            folks[receiver][:presents] += 1
            giver[:presents] -= 1
        end
    end
end


# Do a little reasonableness-checking at the end!
folks.each_with_index do |person, index|
    if person[:presents] < 0
        puts "Person #{index} has less than zero gifts!"
    end
end

# Print it all out
JSON.pretty_generate(folks)
