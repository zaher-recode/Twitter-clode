class UserController < Sinatra::Base

    
    register Sinatra::ActiveRecordExtension

    configure do
        set :views, "app/views"
        set :public_dir, "public"
        #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
        enable :sessions
        set :session_secret, "secret"
    end

  # Renders the sign up/registration page in app/views/registrations/signup.erb
  get '/registrations/signup' do
    erb :'/registrations/signup'

  end

   # Handles the POST request when user submits the Sign Up form. Get user info from the params hash, creates a new user, signs them in, redirects them. 
   post '/registrations' do
    user = User.create(name: params["name"], email: params["email"])
    user.password = params["password"]  # we removed , password: params["password"] from above as we no longer have password column
    user.save
    session[:user_id] = user.id
    if user.id
      redirect "users/home" 
    else
      @message = "User or Email is already used"
      redirect '/registrations/signup'
    end
  end

    # Renders the user's individual home/account page. 
    get '/users/home' do
      @user = User.find(session[:user_id])
      @urls=Url.where(user_id: session[:user_id]).order(id: :desc)
      @num = @urls.count
      erb :'/users/home'
  
    end


    # Renders the view page in app/views/sessions/login.erb
    get '/sessions/login' do
      erb :'sessions/login' 
      
     end

    post '/sessions' do
      user = User.find_by(email: params["email"])
      if user.password ==  params["password"]
      session[:user_id] = user.id
      redirect "users/home"
      else
        @message = "Invalid Username or Password"
        redirect '/sessions/login'
      end
    end

   
      # Logs the user out by clearing the sessions hash. 
    get '/sessions/logout' do
      session.clear
      redirect "/"
    end



    
end
