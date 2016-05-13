Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  root 'home#index'

  post 'instagram/tag/buscar' => 'home#searchTag'
end
