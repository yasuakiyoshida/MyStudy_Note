module EnumHelpRansack
  extend ActiveSupport::Concern

  module ClassMethods
    def enums_i18n_ransack(enum_name)
      enums = eval("self.#{enum_name.to_s.pluralize}")
      enums.map { |k, v| [eval("self.#{enum_name.to_s.pluralize}_i18n")[k], v] }
    end
  end
end