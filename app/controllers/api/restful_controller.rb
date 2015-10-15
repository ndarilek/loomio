class API::RestfulController < ActionController::Base
  snorlax_used_rest!

  include ::ProtectedFromForgery

  before_filter :authenticate_user_by_token, if: :attempt_token_authentication?

  def create_action
    @event = service.create({resource_symbol => resource, actor: current_user})
  end

  def update_action
    @event = service.update({resource_symbol => resource, params: resource_params, actor: current_user})
  end

  def destroy_action
    service.destroy({resource_symbol => resource, actor: current_user})
  end

  private

  def permitted_params
    @permitted_params ||= PermittedParams.new(params)
  end

  def load_and_authorize(model, action = :show)
    instance_variable_set :"@#{model}", ModelLocator.new(model, params).locate
    authorize! action, instance_variable_get(:"@#{model}")
  end

  def attempt_token_authentication?
    !current_user && (request.headers['Loomio-User-Id'] || request.headers['Loomio-API-Key'])
  end

  def authenticate_user_by_token
    if user = User.find_by(id: request.headers['Loomio-User-Id'], email_api_key: request.headers['Loomio-API-Key'])
      sign_in user
    else
      head :unauthorized
    end
  end

  def service
    "#{resource_name}_service".camelize.constantize
  end

  def public_records
    resource_class.visible_to_public.order(created_at: :desc)
  end

  def respond_with_resource(scope: {}, serializer: resource_serializer, root: serializer_root)
    if resource.errors.empty?
      response_options = if @event.is_a?(Event)
        { resources: [@event], scope: scope, serializer: EventSerializer, root: :events }
      else
        { resources: [resource], scope: scope, serializer: serializer, root: root }
      end
      respond_with_collection response_options
    else
      respond_with_errors
    end
  end

end
