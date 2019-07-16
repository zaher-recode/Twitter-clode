class TweetController  < Sinatra::Base


   configure do
       set :views, "app/views"
   set :public_dir, "public"
   end
   register Sinatra::ActiveRecordExtension



delete '/tweets/:id' do
    Tweet.find(params[:id]).destroy
    redirect "/users/home"
  end
  
  get '/tweets/:id/edit' do  #load edit form
      @tweet = Tweet.find(params[:id])
      erb :"tweets/edit" #??
  end
  
  put '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    tweet.name = params[:name]
    tweet.save
    redirect "/tweets/#{@tweet.id}"
  end
end
