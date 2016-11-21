module KeyService
  class Renew < ::KeyService::Base

    class << self

      # Input:
      #   Key: Valid key
      # Returns:
      #   true if succeeds
      #   false  if fails (validation or transaction)
      #
      def call(key)
        key = ::Key.assigned.where(token: key).first
        if key.present?
          key.keep_alive!
          return {
              success: true
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