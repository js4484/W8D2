# == Schema Information
#
# Table name: shortened_urls
#
#  id        :bigint           not null, primary key
#  long_url  :string           not null
#  short_url :string           not null
#  user_id   :integer          not null
#

require 'SecureRandom'

class ShortenedURL < ApplicationRecord
    validates :user_id, presence: true
    validates :short_url, presence: true, uniqueness: true
    validates :long_url, presence: true
    
    def self.random_code
        code = SecureRandom::urlsafe_base64
        
        until !ShortenedURL.exists?(short_url: code)
            code = SecureRandom::urlsafe_base64
        end
        code             
    end

    def create!(user, long_url)
        short_url = self.random_code
        new_url = ShortenedURL.new(user.id, short_url, long_url)
        new_url.create
    end

    belongs_to :submitter,
        class: :User,
        rimary_key: :id,
        foreign_key: :user_id
    
    

end
