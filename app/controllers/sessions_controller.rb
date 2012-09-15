class SessionsController < ApplicationController
  def new
    authorize!(:access, :sessions)
    if(session[:remember_token])
      redirect_to root_path
    else
      @title = "Login"
    end
  end

  def create
    authorize!(:access, :sessions)
    user = User.authenticate(params[:session][:username].downcase, params[:session][:password])
    if user.nil?
      @title = "Login"
      flash.now[:error] = "The username or password you entered were invalid"
      render 'new'
    else
      #log them in and take them somewhere
      login(user)
      redirect_back_or(root_path)
      session[:return_to] = nil
    end
  end

  def destroy
    authorize!(:access, :sessions)
    session[:return_to] = nil
    log_out
    redirect_to login_path
  end

  def preauth
    authorize!(:access, :sessions)
    if session[:remember_token] || !params[:key]
      redirect_to login_path and return
    end
    require 'crypt/rijndael'
    rijndael = Crypt::Rijndael.new(preauth_key,256,128)
    decrypted_string = ''
    params[:key].scan(/.{1,32}/).each do |block|
      if block.length != 32
        redirect_to login_path and return
      end
      decrypted_string = "#{decrypted_string}#{rijndael.decrypt_block(block.to_byte_string)}"
    end
    begin
      tokens = decrypted_string.strip.split('|')
    rescue
      #there was a weird problem with the string...it wasn't in ASCII
      redirect_to login_path and return
    end
    if tokens.length != 2 || tokens[0].match(/^f\d+$/).nil? || tokens[1] != tokens[1].to_i.to_s
      redirect_to login_path and return
    end
    timestamp = Time.now.to_i
    if timestamp - tokens[1].to_i > 300
      #the link was created more than 5 minutes ago...so don't let them in automatically
      redirect_to login_path and return
    end
    user = User.find_by_username(tokens[0].downcase)
    if user.nil?
      flash[:error] = "This appears to be your first time using this application.  Please verify your login credentials."
      redirect_to login_path
    else
      #the decryption worked and the user exists.  Log them in.
      login(user)
      redirect_to root_path
      session[:return_to] = nil
    end
  end

end
