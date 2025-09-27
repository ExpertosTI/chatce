module BrandConfig
  INSTALLATION_NAME = 'CHATCE'
  BASE_URL = 'https://final.renace.tech'
  SUPPORT_EMAIL = 'support@renace.tech'
  WIDGET_BRAND_URL = 'https://final.renace.tech'
  
  def self.setup
    GlobalConfigService.create_or_update(
      'INSTALLATION_NAME', INSTALLATION_NAME,
      'BASE_URL', BASE_URL,
      'SUPPORT_EMAIL', SUPPORT_EMAIL,
      'WIDGET_BRAND_URL', WIDGET_BRAND_URL
    )
  end

  def self.domains
    [
      'final.renace.tech',
      'api.renace.tech',
      'app.chatce.com'
    ]
  end
end