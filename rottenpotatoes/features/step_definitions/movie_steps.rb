Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)

  end
end

Then /I should (not )?see movies rated: (.*)/ do |negation, rating_list|
  if rating_list.eql?("all")
    ratings = Movie.group(:rating).map(&:rating)
  else
    ratings = rating_list.split(",")
    ratings = Movie.all_ratings - ratings if negation
  end
  db_size = filtered_movies = Movie.find(:all, :conditions => {:rating => ratings}).size
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do | rating |
    rating = "ratings_" + rating
    if uncheck
      uncheck(rating)
    else
      check(rating)
    end
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  body = page.body.to_s
  e1_index = body.index(e1)
  e2_index = body.index(e2)
  assert e1_index < e2_index
end

Then /the director of "(.*)" should be "(.*)"/ do |movie, director|
  page.should have_content(movie)
  page.should have_content(director)
end