module KeyService
  class Assign < ::KeyService::Base

    class << self

      # Returns:
      #   success: true/false
      #   key: valid key if success else nil
      #
      # Endpoint E2: There should be an endpoint to get an available key. On hitting this endpoint server should serve a
      # random key which is not already being used. This key should be blocked and should not be served again by E2,
      # till it is in this state. If no eligible key is available then it should serve 404.
      def call
        random_key = ::Key.available.first
        if random_key.blank?
          return {
              success: false,
              key: nil
          }
        else
          assigned = random_key.set_assigned!
          if assigned
            return {
                success: true,
                key: random_key
            }
          else
            return {
                success: false,
                key: nil
            }
          end
        end
      end
    end
  end
end