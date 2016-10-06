require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

def create_membership(params)
  if current_user && !Member.create(user_id: current_user.id, meetup_id: params[:meetup][:id]).save
    flash[:notice] = "You have already joined this meetup!"
  elsif current_user
    Member.create(user_id: current_user.id, meetup_id: params[:meetup][:id])
  elsif current_user.nil?
    @login = "You must log in!"
  elsif Member.create(user_id: current_user.id, meetup_id: params[:meetup][:id]).save

  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.sort_by { |meetup| meetup.name.downcase }

  erb :'meetups/index'
end


get '/meetups/new' do
  @meetup = Meetup.new

  if current_user
    @curent_user = current_user
  end

  erb :new
end

post "/meetups/:id/members" do
  create_membership(params)
  redirect "/meetups/#{params[:meetup][:id]}"
end

get "/meetups/:id" do

  @meetup = Meetup.find(params[:id])
  @current_user = current_user
  @users = @meetup.users
  erb :show
end

post '/meetups' do
  @meetup = Meetup.new(params[:meetup])
  @error = nil
  @login = nil
  if current_user.nil? && @meetup.save == false
    @login = "You must log in!"
    @error = @meetup.errors.full_messages
    erb :new
  elsif current_user && @meetup.save
    meetup = Meetup.last
    flash[:notice] = "YOU MADE A SUCCESSFUL MEETUP"
    redirect "/meetups/#{meetup.id}"
  elsif current_user.nil? && @meetup.save == true
    @login = "You must log in!"
    erb :new
  else
    @error = @meetup.errors.full_messages
    erb :new
  end
end
