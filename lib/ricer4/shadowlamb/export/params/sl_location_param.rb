module ActiveRecord::Magic::Param
  class SlLocation < ShadowlambParam
    def input_to_value(input)
      input = input.downcase
      locations = Ricer4::Plugins::Shadowlamb::Core::Shadowverse.instance.locations
      candidates = locations.select{|location|location.guid.gsub('::','/').downcase.end_with?(input)}
      raise Ricer4::ExecutionException(I18n.t("shadowlamb.err_unknown_location")) if candidates.count == 0
      raise Ricer4::ExecutionException(I18n.t("shadowlamb.err_location_ambigious")) if candidates.count > 1
      candidates.first
    end
  end
end
