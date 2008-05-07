module ActionView
  class Base
    include Astrails::Linguist::Helper
  	def language_link(lang)
      target = (request.get? ? params : ActionController::Routing::Routes.recognize_path('/')).merge(:lang => lang, :set_lang => true)

      link_to_unless(current_language == lang, lang, target)
    end
  end
end
