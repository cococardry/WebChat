class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    validates_format_of :username, with: /^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$/, :multiline => true

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable
    sync :all
    has_many :friendships
    has_many :friends, :through => :friendships

    has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
    has_many :inverse_friends, :through => :inverse_friendships, :source => :user
    has_many :conversations, :foreign_key => :sender_id

       def login=(login)
         @login = login
       end

       def login
         @login || self.username || self.email
       end

       def self.find_first_by_auth_conditions(warden_conditions)
         conditions = warden_conditions.dup
          if login = conditions.delete(:login)
            where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
          else
            if conditions[:username].nil?
              where(conditions).first
            else
              where(username: conditions[:username]).first
            end
        end
      end

      def unread(user, friend)
        converstaion = Conversation.between(user.id, friend.id).first
        if !converstaion.nil?
          converstaion.messages.where(read: false, user_id: friend.id).count
        else
          0
        end
      end
end
