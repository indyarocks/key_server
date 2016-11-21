Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: APIConstraints.new(version: 1, default: true) do
      resources :keys, only: [:destroy] do
        collection do
          post '/generate' => 'keys#generate_keys'
          put '/assign' => 'keys#assign'
        end

        member do
          put '/release' => 'keys#release'
          put '/keep-alive' => 'keys#keep_alive'
        end
      end
    end
  end

end
