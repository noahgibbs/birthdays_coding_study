# birthdays.rb

# If folks were to give out presents on their *own* birthdays, would it make
# sense to have many friends, or few? To be a miser or give it all away?

MANY = 10

folks = (1..MANY).map {
    {
        friendly: rand(4) + 1,
        miserly: rand(4) + 1,
        presents: 3,  # They all have a little something laying around
    }
}

# Have a bunch of birthdays... Everybody gets one per year.
# No deaths, that's morbid. Just constant gift-giving.
100.times do
    folks.each do |giver|

    end
end
