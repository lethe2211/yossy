# Sessions Controller
class SessionsController < ApplicationController
  # /sessions
  def index
    render 'new'
  end
  
  # /sessions/create
  def create
    user = User.find_by_name params[:name]
    # Authentication
    if user && user.authenticate(params[:pass])
      session[:user_id] = user.id
      redirect_to :controller => 'booklist', :action => 'index'
    else
      render 'login_failure'
    end
  end

  # /sessions/logout
  def logout
    session[:user_id] = nil
  end
end
