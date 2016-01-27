module ShareProgress
  class Railtie < Rails::Railtie
    initializer 'Rails logger' do
      MyGem.logger = Rails.logger
    end
  end
end