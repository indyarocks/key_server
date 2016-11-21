module KeyService
  class Delete < ::KeyService::Base

    class << self

      # Input:
      #   number_of_keys: Valid positive Integer
      # Returns:
      #   true if succeeds
      #   false  if fails (validation or transaction)
      #
      def call(key)
        key = ::Key.where(token: key).first
        if key.present?
          response = key.set_deleted!
          return {
              success: response
          }
        else
          return {
              success: false
          }
        end
      end
    end
  end
end