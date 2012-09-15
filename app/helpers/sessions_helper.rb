module SessionsHelper
  def login(user)
    session[:remember_token] = user.id
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:remember_token])
  end

  def log_out
    session[:remember_token] = nil
    self.current_user = nil
  end

  def deny_access
    set_return_to
    redirect_to(login_path)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def set_return_to
    session[:return_to] = request.fullpath
  end

  private

    def clear_return_to
      session[:return_to] = nil
    end

    def preauth_key
      "ENTER YOUR SECRET BLOWFISH KEY HERE" #needs to be 32 characters long
    end
  
end
