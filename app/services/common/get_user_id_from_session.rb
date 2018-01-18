module Common
  class GetUserIdFromSession < BaseService
    def call(session)
      session['warden.user.user.key'][0][0]
    end
  end
end
