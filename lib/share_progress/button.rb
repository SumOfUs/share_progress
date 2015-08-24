require 'share_progress'
require 'share_progress/client'

module ShareProgress
  class Button

    def self.new
    end

    def self.update
    end

    def self.find(id)
      Client.get endpoint('read'), { query: { id: id } }
    end

    def self.destroy(id)
      Client.get endpoint('delete'), { id: id }
    end

    def self.all(options={})
      acceptable = [:offset, :limit]
      Client.get endpoint, { query: stringify_keys(filter_keys(options, acceptable)) }
    end

    private

    def self.endpoint(method=nil)
      extension = method.nil? ? "" : "/#{method}"
      "/buttons#{extension}"
    end

    def self.filter_keys(params, acceptable)
      params.select{ |key, _| acceptable.include? key }
    end

    def self.stringify_keys(h)
      n = {}
      h.each_pair { |k, v| n[k.to_s] = v}
      n
    end

  end
end