raise "Please define SUPPORTED_LANGUAGES" unless defined? SUPPORTED_LANGUAGES
raise "Please define DEFAULT_GETTEXT_DOMAIN" unless defined?(DEFAULT_GETTEXT_DOMAIN)
# FIXME: test that home_path defined

require 'astrails/linguist'
