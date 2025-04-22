class HealthRoutes < Sinatra::Base
  use AuthMiddleware

  get('/') do
    'App working OK'
  end
end
