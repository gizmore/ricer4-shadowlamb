module Ricer4::Plugins::Shadowlamb::Core::Include::Guid
  
    def guid; self.class.guid; end
    def i18n_key; @i18n_key ||= guid.downcase.gsub('::', '.'); end
    def display_name;_display_name; end
    def _display_name; t!("shadowlamb.world.#{i18n_key}.name") rescue default_name; end
    def default_name; @default_name ||= guid.gsub('::', '/'); end
    def displayinfo;_displayinfo; end
    def _displayinfo; t!("shadowlamb.world.#{i18n_key}.info") rescue defaultinfo; end
    def defaultinfo; "#{i18n_key}.info - No info yet."; end

end
