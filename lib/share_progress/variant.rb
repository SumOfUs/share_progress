require 'share_progress'
require 'share_progress/client'
require 'share_progress/errors'
require 'share_progress/button'

module ShareProgress
  class Variant
    attr_accessor :button, :id
    attr_reader   :errors

    def initialize(params=nil)
      update_attributes(params) unless params.nil?
    end

    def to_s
      self.serialize.to_json
    end

    def save
      add_error('button', "can't be blank") and return false if @button.nil?
      add_error('button', "must have an id") and return false if @button.id.nil?
      response = Button.update(id: @button.id, variants: {type => [serialize]})
      return false unless response.is_a? Hash
      @errors = parse_errors(response['errors'])
      (@errors.size > 0)
    end

    def serialize
      serialized = Hash.new
      all_fields.each do |field|
        serialized[field] = send(field)
      end
      serialized
    end

    def update_attributes(params)
      if params.is_a? Variant
        params.instance_variables.each do |key|
          instance_variable_set(key, params.instance_variable_get(key))
        end
      elsif params.is_a? Hash
        Utils.symbolize_keys(params).each_pair do |key, value|
          @button = value if key == :button
          instance_variable_set("@#{key}", value) if all_fields.include? key
        end
      end
    end

    def all_fields
      self.class.fields + [:id]
    end

    def type
      self.class.type
    end

    def set_analytics(analytics:)
      # Thinking at the moment that it makes sense to keep this as a basic hash, though
      # we might need to extend its functionality down the road.
      @analytics = analytics
    end

    def analytics
      if @analytics
        @analytics
      else
        raise AnalyticsNotFound
      end
    end

    private

    def add_error(field, message)
      @errors ||= {}
      @errors[field.to_s] ||= []
      @errors[field.to_s].push(message)
    end

    def parse_errors(errors)
      begin
        messages = errors['variants'][0]
        return {} if messages.nil?
      rescue NoMethodError, KeyError, IndexError
        return {}
      end
      # it concatenates the field and the error into a full message
      output = {}
      messages.map{|msg| msg.split(' ', 2)}.each do |field, error|
        output[field] ||= []
        output[field].push error
      end
      output
    end

  end
end

