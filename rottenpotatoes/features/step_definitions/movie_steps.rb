Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

Then(/^the director of "(.*?)" should be "(.*?)"$/) do |movie_title, movie_director|
  movie = Movie.find_by_title(movie_title)
  assert page.has_content?(movie.director)
end

Then(/^I should be on the Similar Movies page for "(.*?)"$/) do |movie_title|
  movie = Movie.find_by_title(movie_title)
  visit with_the_same_director_path(id: movie.id)
end