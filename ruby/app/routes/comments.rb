require_relative '../controllers/comments'

class CommentRoutes < Sinatra::Base
  def initialize
    super
    @commentctrl = CommentController.new
  end

  before do
    content_type :json
  end

  get '/articles/:article_id/comments' do
    article_id = params["article_id"].to_i
    comments = @commentctrl.get_comments(article_id)
    if comments[:ok]
      {comments: comments[:data]}.to_json
    else
      { msg: comments[:msg]}.to_json
    end
  end

  post '/articles/:article_id/comments' do
    payload = JSON.parse(request.body.read)
    payload['article_id'] = params['article_id'].to_i
  
    summary = @commentctrl.create_comment(payload)
    if summary[:ok]
      { msg: 'Comment created', id: summary[:obj].id }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end
  

  delete '/comments/:id' do
    summary = @commentctrl.delete_comment params['id']
    if summary[:ok]
      { msg: 'Comment deleted' }.to_json
    else
      { msg: 'Comment does not exist' }.to_json
    end
  end
end
