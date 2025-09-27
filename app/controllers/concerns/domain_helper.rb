module DomainHelper
  def self.chatwoot_domain?(domain = request.host)
    [URI.parse(ENV.fetch('FRONTEND_URL', '')).host, URI.parse(ENV.fetch('HELPCENTER_URL', '')).host].include?(domain)
  end

  # Alias for rebranding to CHATCE. Keep as a thin wrapper to preserve
  # existing behavior while allowing callers to migrate to chatce naming.
  def self.chatce_domain?(domain = request.host)
    chatwoot_domain?(domain)
  end
end
