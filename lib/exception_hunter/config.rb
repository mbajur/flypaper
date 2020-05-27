module ExceptionHunter
  class Config
    cattr_accessor :enabled, default: true
    cattr_accessor :errors_stale_time, default: 45.days
    cattr_accessor :current_user_method, :user_attributes
  end
end
