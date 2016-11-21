module KeyService
  class Release < ::KeyService::Base

    class << self

      # Input:
      #   key: valid key
      # Returns:
      #   true if succeeds
      #   false  if fails (validation or transaction)
      # # Endpoint E3: There should be an endpoint to unblock a key. Unblocked keys can be served via E2 again.
      def call(key)
        assigned_key = ::Key.assigned.where(token: key).first
        if assigned_key.blank?
          return {
              success: false
          }
        else
          assigned_key.set_released!
          return {
              success: true
          }
        end
      end
    end
  end
end