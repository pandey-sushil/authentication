Authentication::Engine.routes.draw do

  resource :session, only: [], controller: 'sessions', path: '' do
    # post :create,     path: '/:entity/login'
    # delete :destroy,  path: '/:entity/logout'
  end

  resource :registration, only: [], controller: 'registrations', path: '' do
    # post :create,     path: '/:entity/register'
  end

end
