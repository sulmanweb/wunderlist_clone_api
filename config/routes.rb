Rails.application.routes.draw do
  namespace :v1 do
    namespace :auth do
      get 'sessions/create'
    end
  end

  match '/404', to: 'error/errors#not_found', via: :all

  match '/500', to: 'error/errors#internal_server_error', via: :all

  get '/api-docs/v1' => redirect('/dist/index.html?url=/apidocs/apidocs_v1.json')

  namespace :v1 do
    namespace :auth do
      post 'sign_up', to: 'registrations#create'
      post 'sign_in', to: 'sessions#create'
    end
  end
end
