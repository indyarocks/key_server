module API
  module V1
    class KeysController < ::API::V1::BaseController

      before_action release_assigned_keys: :assign

      # Endpoint E1: There should be one endpoint to generate keys.
      def generate_keys
        params[:keys_count] = (params[:keys_count].to_i > 0) ? params[:keys_count].to_i : 10
        response = ::KeyService::Generate.call(number_of_keys: params[:keys_count])
        render json: { success: response }
      end

      # Endpoint E2: There should be an endpoint to get an available key. On hitting this endpoint server should serve a
      # random key which is not already being used. This key should be blocked and should not be served again by E2,
      # till it is in this state. If no eligible key is available then it should serve 404.
      def assign
        response = ::KeyService::Assign.call
        if response[:success]
          render json: response
        else
          render json: response, status: 404
        end
      end

      # Endpoint E3: There should be an endpoint to unblock a key. Unblocked keys can be served via E2 again.
      # ASSUMPTION: Only assigned key can be released
      def release
        response = ::KeyService::Release.call(params[:id])
        render json: response
      end

      # Endpoint E4:  There should be an endpoint to delete a key. Deleted keys should be purged.
      def destroy
        response = ::KeyService::Delete.call(params[:id])
        render json: response
      end

      # Endpoint E4: All keys are to be kept alive by clients calling this endpoint every 5 minutes. If a particular 
      # key has not received a keep alive in last five minutes then it should be deleted and never used again. 
      # ASSUMPTION: New keys will remain alive, only assigned key will require keep_alive
      def keep_alive
        response = ::KeyService::Renew.call(params[:key])
        render json: response
      end

      private
      def release_assigned_keys
        ::Key.assigned.where('assigned_at >= ?', Time.current - 1.minute)
            .update_all(
                status: :released,
                released_at: Time.current
            )
      end
    end
  end
end

