Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tipos_combustivel, controller: :combustiveis
      resources :tanques
      resources :bombas
      resources :bicos
      resources :funcionarios
      resources :caixas_turno, controller: :caixas
      resources :produtos
      resources :fornecedores
      resources :clientes
      resources :veiculos
      resources :vendas
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
