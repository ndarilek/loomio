class GroupSubdomainConstraint
  def self.matches?(request)
    if is_in_sandstorm?
      false
    else
      request.subdomain.present? && (request.subdomain != 'www')
    end
  end
end

