require 'rails/generators/active_record'

module ExceptionHunter
  class InstallGenerator < ActiveRecord::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :name, type: :string, default: 'AdminUser'
    hook_for :users, default: 'create_users', desc: 'Admin user generator to run. Skip with --skip-users'

    def copy_initializer
      @underscored_user_name = name.underscore.gsub('/', '_')
      @use_authentication_method = options[:users].present?
      template 'exception_hunter.rb.erb', 'config/initializers/exception_hunter.rb'
    end

    def setup_routes
      if options[:users]
        gsub_file 'config/routes.rb',
                  "\n  devise_for :#{plural_table_name}, skip: :all",
                  "\n  mount ExceptionHunter::Engine => 'exception_hunter'"
      else
        route "mount ExceptionHunter::Engine => 'exception_hunter'"
      end
    end

    def create_migrations
      migration_template 'create_exception_hunter_error_groups.rb.erb',
                         'db/migrate/create_exception_hunter_error_groups.rb'
      migration_template 'create_exception_hunter_errors.rb.erb', 'db/migrate/create_exception_hunter_errors.rb'
    end
  end
end
