class API::TranslationsController < API::RestfulController

  private

  def resource
    @resource ||= translations_for(params[:lang]).deep_merge
                  translations_for(:en)
  end

  def translations_for(locale)
    YAML.load_file("config/locales/client.#{locale}.yml")[locale.to_s]
  end
end
