Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


	get '/tickets', to: 'tickets#index'
	post '/tickets', to: 'tickets#create'
	get '/tickets/new', to: 'tickets#new', as: 'new_tickets'
	get 'tickets/:id', to: 'tickets#show'

	root :to => 'application#index'
	post '/', to: 'application#create'

end