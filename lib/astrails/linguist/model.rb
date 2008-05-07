# attributes support
module ActiveRecord
  class Base
    include Astrails::Linguist::Helper
    # simple helper to support model attributes like name_en/name_fr/name_de etc
    def self.intl_attr(attr_name)
      define_method(attr_name) do
        res = self.send("#{attr_name}_#{current_language}")
        res.blank? ? self.send("#{attr_name}_#{EMPTY_LANGUAGE}") : res
      end
    end
  end


  # Error Messages
  class Errors
    def localize_error_message_with_intl(attr, msg, append_field)
      msg = msg.call if msg.is_a?(Proc)

      if msg =~ /^\^/
        localize_error_message_without_intl(attr, msg, false)[1..-1]
      else
        localize_error_message_without_intl(attr, msg, append_field)
      end
    end
    alias_method_chain :localize_error_message, :intl
  end
end

