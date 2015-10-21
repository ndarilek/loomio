require "uuid"

module Devise
  module Strategies
    class Sandstorm < Authenticatable
      def authenticate!
        # puts "Headers: #{request.headers.inspect}"
        userid = request.headers['HTTP_X_SANDSTORM_USER_ID'].encode(Encoding::UTF_8)
        handle = request.headers['HTTP_X_SANDSTORM_PREFERRED_HANDLE'].encode(Encoding::UTF_8)
        username = URI.unescape(request.headers['HTTP_X_SANDSTORM_USERNAME']).force_encoding(Encoding::UTF_8)
        permissions = request.headers['HTTP_X_SANDSTORM_PERMISSIONS']
        is_admin = permissions.include?("admin")
        u = User.where(username: userid).first
        if u
          u.is_admin = is_admin
          u.name = username
          u.username = userid
          u.save
        else
          opts = {}
          opts[:name] = username
          opts[:is_admin] = is_admin
          opts[:username] = userid
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