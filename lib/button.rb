require 'share_progress'

class Button
  def initialize
    @connection = ShareProgress::ConnectionFactory.get_connection
  end
end
