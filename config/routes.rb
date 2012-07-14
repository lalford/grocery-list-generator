GroceryListGenerator::Application.routes.draw do
  resources :grocery_lists do
    get :generate, :on => :member
  end

  resources :recipes do
    get :autocomplete_recipe_name, :on => :collection
  end

  resources :labels

  resources :foods do
    get :autocomplete_food_name, :on => :collection
  end

  resources :store_sections

  root :to => 'grocery_lists#new'
end
