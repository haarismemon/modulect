require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjectRun
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Load all subclasses of the Tag model
    config.autoload_paths += %W(#{config.root}/app/models/tags)
    config.to_prepare do
          Administrate::ApplicationController.helper ProjectRun::Application.helpers
        end
  end
end
