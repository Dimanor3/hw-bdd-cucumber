# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  debugger
  fail "Unimplemented" 
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |rating|
    string = "ratings_" + rating
    
    if uncheck
       step(%Q{I uncheck "#{string}"})
    else
      step(%Q{I check "#{string}"})
    end
  end
  
end



Then /I should see movies rated: (.*)/ do |ratings_string|
  ratings_array = ratings_string.split(", ")
  
  #get the table that came back
  table = page.all("tr")
  
  #drop 1 to remove the table headers
  table.drop(1).each do |row|
    #split at date column
    row_split_at_date = row.text.split(/\d{4}-\d{2}-\d{2}/)
    
    #take name and rating, remove white space, and split into pieces
    #last piece is rating
    name_and_rating = row_split_at_date[0].strip.split(" ")
    rating = name_and_rating.last
    
    #check that ratings_array includes rating
     fail "Rating not in ratings list" unless ratings_array.include? rating 
      
  end
end

Then /I should not see movies rated: (.*)/ do |ratings_string|
  ratings_array = ratings_string.split(", ")
  
  #get the table that came back
  table = page.all("tr")
  
  #drop 1 to remove the table headers
  table.drop(1).each do |row|
    #split at date column
    row_split_at_date = row.text.split(/\d{4}-\d{2}-\d{2}/)
    
    #take name and rating, remove white space, and split into pieces
    #last piece is rating
    name_and_rating = row_split_at_date[0].strip.split(" ")
    rating = name_and_rating.last
    
    #check that ratings_array includes rating
    fail if ratings_array.include? rating
  end
end



Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all
end
