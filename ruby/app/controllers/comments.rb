class CommentController
  def create_comment(comment)
    new_comment = Comment.new(:author_name => comment['author_name'], :content => comment['content'] , 
                              :article_id => comment['article_id'], :created_at => Time.now)
    new_comment.save
    { ok: true, obj: new_comment }
  rescue ActiveRecord::InvalidForeignKey
    { ok: false, msg: 'Invalid article_id' }
  
  rescue StandardError
    { ok: false }
  end

  def get_comments(article_id)
    comments = Comment.where(:article_id => article_id).to_a
    {ok: true, data: comments }
  end

  def delete_comment(comment_id)
    delete_count = Comment.delete(comment_id)

    if delete_count == 0
      { ok: false, delete_count: delete_count }
    else
      { ok: true, delete_count: delete_count }
    end
  end
end
