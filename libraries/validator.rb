module GameKeeper
  module Validator

    def valid(key, params, type = nil)
      value = params[key]

      if value.nil?
        throw "#{key} can't be nil in params supplied to definition"
      elsif type && !value.is_a?(type)
        throw "#{key} was expected to be of type #{type}"
      end

      value
    end

  end
end

Chef::Recipe.send(:include, GameKeeper::Validator)
