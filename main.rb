require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'sinatra/activerecord'

#need to fix movies to reflect table change

set :database, {adapter: "postgresql",
                database: "Homework",
                host: 'localhost',
                username: 'postgres',
                password: 'postgres'}

#shows root page

get '/' do
  sql = "select * from tasks"
  @tasks = run_sql(sql)

  sql = "select * from movies"
  @movies = run_sql(sql)

  sql = "select * from people"
  @people = run_sql(sql)

  erb :index
end

#shows form to add a new movie
get '/movies/new' do
  sql = "select id, name from people"
  @people = run_sql(sql)
  erb :new_movie
end

#adds a new movie
#Bug: doesn't like Movies with ' in the title
post '/movies/new' do
  @name = params[:name]
  @release_date = params[:release_date]
  @director = params[:director]
  sql = "insert into movies (name,release_date,director) values ('#{@name}','#{@release_date}', '#{@director}')"
  run_sql(sql)
  redirect to '/'
end

#shows form to edit movie
get '/movies/:id/edit' do
  @id = params[:id]
  @name = params[:name]
  @title = params[:title]
  @release_date = params[:release_date]
  @director = params[:director]
  sql = "select * from movies where id = #{@id}"
  @movie = run_sql(sql).first
  erb :movie_edit
end

#this edits the movie
#Bug: doesn't like Movies with ' in the title
post '/movies/:id/edit' do
  @id = params[:id]
  @name = params[:name]
  @release_date = params[:release_date]
  @person_id = params[:director]
  sql = "update movies set (name,release_date) = ('#{@name}', '#{@release_date}') where id = #{@id}"
  run_sql(sql)
  redirect to "/"
end

#this deletes the movie
#problem deleting movie that is associated in the task table
post '/movies/:id/delete' do
  @id = params[:id]
  sql = "delete from movies where id = #{@id}"
  run_sql(sql)
  redirect to "/"
end

#shows form to add a new person
get '/people/new' do
  erb :new_person
end

#adds a new person
post '/people/new' do
  @name = params[:name]
  @title = params[:title]
  sql = "insert into people (name,title) values ('#{@name}', '#{@title}')"
  run_sql(sql)
  redirect to '/'
end

#shows form to edit person
get '/people/:id/edit' do
  @id = params[:id]
  @name = params[:name]
  @title = params[:title]
  sql = "select * from people where id = #{@id}"
  @person = run_sql(sql).first
  erb :person_edit
end

#this edits the person
post '/people/:id/edit' do
  @id = params[:id]
  @name = params[:name]
  @title = params[:title]
  sql = "update people set (name,title) = ('#{@name}', '#{@title}') where id = #{@id}"
  run_sql(sql)
  redirect to "/"
end

#this deletes the person
#problem deleting person who is referenced in the tasks table XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
post '/people/:id/delete' do
  @id = params[:id]
  sql = "delete from people where id = #{@id}"
  run_sql(sql)
  redirect to "/"
end

#shows the form to add a new task
get '/tasks/new' do
  sql = "select id, name from people"
  @people = run_sql(sql)
  sql = "select id, name from movies"
  @movies = run_sql(sql)
  erb :new_task
end

#adds a new task
post '/tasks/new' do
  @name = params[:name]
  @description = params[:description]
  @person_id = params[:person_id]
  @movie_id = params[:movie_id]
  sql = "insert into tasks (name,description,person_id,movie_id) values ('#{@name}', '#{@description}','#{@person_id}','#{@movie_id}')"
  @tasks = run_sql(sql)
  redirect to '/'
end

#shows form to edit task
get '/tasks/:id/edit' do
  @id = params[:id]
  @name = params[:name]
  @description = params[:description]
  @person_id = params[:person_id]
  @movie_id = params[:movie_id]
  sql = "select * from tasks where id = #{@id}"
  @task = run_sql(sql).first
  sql = "select * from movies"
  @movies = run_sql(sql)
  sql = "select * from people"
  @people = run_sql(sql)

  erb :task_edit
end

#this edits the task
###########It changes everythign in the database except people and movie id!!!!!!!!!XXXXXXXXXXXXXXXXXX
post '/tasks/:id/edit' do
  @id = params[:id]
  @name = params[:name]
  @description = params[:description]
  @person_id = params[:person_id]
  @movie_id = params[:movie_id]
  sql = "update tasks set (name,description,person_id,movie_id) = ('#{@name}', '#{@description}','#{@person_id}','#{@movie_id}') where id = #{@id}"
  run_sql(sql)
  redirect to "/"
end

#this deletes the task
post '/tasks/:id/delete' do
  @id = params[:id]
  sql = "delete from tasks where id = #{@id}"
  run_sql(sql)
  redirect to "/"
end

#shows individual task
get '/tasks/:id' do
  @id = params[:id]
  @movie_id = params[:movie_id]
  @person_id = params[:person_id]
  sql = "select * from tasks where id = '#{@id}'"
  @task = run_sql(sql).first
  sql = "select * from movies where id = '#{@movie_id}'"
  @movie = run_sql(sql).first
  sql = "select * from people where id = '#{@person_id}'"
  @person = run_sql(sql).first

  erb :task
end


#shows individual movie
get '/movies/:id' do
  @id = params[:id]
  sql = "select * from movies where id = '#{@id}'"
  @movie = run_sql(sql).first
  erb :movie
end

#shows individual person
get '/people/:id' do
  @id = params[:id]
  sql = "select * from people where id = '#{@id}'"
  @person = run_sql(sql).first
  erb :person
end

