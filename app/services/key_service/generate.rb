module KeyService
  class Generate < ::KeyService::Base

    class << self

      # Input:
      #   number_of_keys: Valid positive Integer
      # Returns:
      #   true if succeeds
      #   false  if fails (validation or transaction)
      #
      def call(number_of_keys: 10)
        return false if number_of_keys < 1
        unique_tokens = []
        1.upto(number_of_keys).each do
          token = nil
          loop do
            token = SecureRandom.urlsafe_base64
            break token unless ::Key.find_by(token: token)
          end
          unique_tokens << {token: token}
        end
        ActiveRecord::Base.transaction do
          begin
            ::Key.create!(unique_tokens)
          rescue Exception => ex
            Rails.logger.debug("Exception in generating keys: #{ex.message}\n\n\n\n Backtrace: #{ex.backtrace}")
            return false
          end
        end
        true
      end
    end
  end
end