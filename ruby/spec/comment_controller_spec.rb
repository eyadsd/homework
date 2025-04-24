require 'rspec/autorun'
require 'dotenv'
require_relative '../app/controllers/comments'

describe CommentController do
  let(:controller) { CommentController.new }

  before(:all) do
    require_relative '../config/environment'
    require_relative '../app/models/db_init'
  end

  it 'creates a comment for an article' do
    result = controller.create_comment({
      'article_id' => 1,
      'content' => 'article content',
      'author_name' => 'John'
    })

    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:obj)
    expect(result[:obj]).to be_truthy
    expect(result[:obj].article_id).to eq(1)
    expect(result[:obj].content).to eq('article content')
    expect(result[:obj].author_name).to eq('John')
  end

  it 'fetches all comments for an article' do
    result = controller.get_comments(1)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result).to have_key(:data)
    expect(result[:data]).to be_an(Array)
    expect(result[:data].first[:article_id]).to eq(1)
  end


  it 'fails to create a comment for article that does not exist' do
    result = controller.create_comment({
      'article_id' => 200,
      'content' => 'article content',
      'author_name' => 'John'
    })

    expect(result[:ok]).to be false
    expect(result).to have_key(:msg)
  end

  it 'deletes a comment' do
    create_result = controller.create_comment({
      'article_id' => 1,
      'content' => 'Temp comment',
      'author_name' => 'TestUser'
    })

    comment_id = create_result[:obj].id

    result = controller.delete_comment(comment_id)
    expect(result).to have_key(:ok)
    expect(result[:ok]).to be true
    expect(result[:delete_count]).to eq(1)
  end

  it 'fails to delete a non-existent comment' do
    result = controller.delete_comment(9999)
    expect(result[:ok]).to be false
  end
end
