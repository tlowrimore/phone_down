Rails.application.routes.draw do
  resources :sms_requests, only: [:create]
end
