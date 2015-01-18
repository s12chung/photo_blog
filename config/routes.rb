PhotoBlog::Application.routes.draw do
  resources :markdowns, only: %i[edit update]
  controller :session do
    get '/login' => :new
    post '/login' => :create
  end

  get '/:key' => 'application#markdown', as: :root_markdown, constraints: Markdown::PagesConstraint
  resources :posts, only: %i[index create show edit update destroy], path: "" do
    member do
      patch :toggle_publish
    end
  end
  root 'posts#index'
end