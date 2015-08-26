require 'httparty'

module ShareProgress
  class Utils    
    class << self

      def filter_keys(params, acceptable)
        return params if params.nil?
        params.select!{ |key, _| acceptable.include? key }
      end

      def symbolize_keys(params)
        fresh = Hash.new
        params.each_pair{ |k, v| fresh[k.to_sym] = v }
        fresh
      end

    end
  end
end
