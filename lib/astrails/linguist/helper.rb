module Astrails
  module Linguist
    module Helper
      # true if supported
      def supported_lang?(lang)
        SUPPORTED_LANGUAGES.include?(lang)
      end

      # returns lang as-is for supported languages, default_language instead of junk
      def sanitize_lang(lang)
        supported_lang?(lang) ? lang : DEFAULT_LANGUAGE
      end

      # currently selected language
      def current_language
        GetText.locale.to_s
      end

      # set current_language. returns the old value
      def set_current_language(lang)
        GetText.locale, prev_value = sanitize_lang(lang), GetText.locale
        prev_value
      end

      # localize url/path by prepending /intl/LANG if needed
      def localize_path(path, lang = current_language)

        # no localization for 'special' case
        return path if !lang || EMPTY_LANGUAGE == lang

        # we only localize absolute path/url, like /support
        # we don't localize full urls like http://google.com
        return path unless path[0] == ?/

        # don't localize if already localized, duh!
        return path if path[0..5] == '/intl/'

      "/intl/#{lang}#{path}"
      end
    end
  end
end
