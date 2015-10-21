require "uuid"

module Devise
  module Strategies
    class Sandstorm < Authenticatable
      def authenticate!
        userid = request.headers['HTTP_X_SANDSTORM_USER_ID'].encode(Encoding::UTF_8)
        handle = request.headers['HTTP_X_SANDSTORM_PREFERRED_HANDLE'].encode(Encoding::UTF_8)
        username = URI.unescape(request.headers['HTTP_X_SANDSTORM_USERNAME']).force_encoding(Encoding::UTF_8)
        permissions = request.headers['HTTP_X_SANDSTORM_PERMISSIONS']
        is_admin = permissions.include?("admin")
        avatar_url = request.headers['HTTP_X_SANDSTORM_USER_PICTURE']
        u = User.where(sandstorm_user_id: userid).first
        if u
          u.is_admin = is_admin
          u.name = username
          u.username = handle
          u.sandstorm_avatar_url = avatar_url
          u.save
        else
          opts = {}
          opts[:name] = username
          opts[:is_admin] = is_admin
          opts[:username] = handle
          opts[:sandstorm_user_id] = userid
          opts[:sandstorm_avatar_url] = avatar_url
          opts[:email] = "#{UUID.generate}@#{UUID.generate}.fake"
          u = User.new(opts)
          if u.save
            Rails.logger.info 'User was successfully created.'
          else
            Rails.logger.error 'User could not be created'
            Rails.logger.error u.errors.inspect
          end
        end

        success!(u)
      end
      def valid?
        !!request.headers['HTTP_X_SANDSTORM_USER_ID']
      end
    end
  end
end