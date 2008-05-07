require 'gettext'
require 'gettext/rails'

DEFAULT_LANGUAGE = SUPPORTED_LANGUAGES.first unless defined? DEFAULT_LANGUAGE
EMPTY_LANGUAGE   = SUPPORTED_LANGUAGES.first unless defined? EMPTY_LANGUAGE
LANGUAGE_REGEXP  = /^(#{SUPPORTED_LANGUAGES.join('|')})$/

include GetText
GetText.locale = DEFAULT_LANGUAGE
ActionController::Base.init_gettext(DEFAULT_GETTEXT_DOMAIN)

require 'astrails/linguist/helper'
require 'astrails/linguist/routing'
require 'astrails/linguist/model'
require 'astrails/linguist/view'
require 'astrails/linguist/controller'

class ApplicationController < ActionController::Base
 include Astrails::Linguist::Controller
end
