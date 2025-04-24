class Article < ActiveRecord::Base 
  self.table_name = 'articles'
  has_many :comments
end
