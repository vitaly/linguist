module Astrails
  module Linguist
    module Controller
      def self.included(base)
        base.class_eval do
          before_filter :set_language
        end
      end

      protected
      include Astrails::Linguist::Helper

      def has_session?
        @_session && @_session.respond_to?(:session_id)
      end

      def set_language
        lang = params[:lang] || EMPTY_LANGUAGE

        set_current_language(lang)

        return true unless request.get? && has_session?

        # first visit. no language set => redirect to default
        if session[:lang].blank? && params[:lang].blank? && DEFAULT_LANGUAGE != lang
          logger.info "redirecting to default language #{DEFAULT_LANGUAGE}"
          redirect_to params.merge(:lang => DEFAULT_LANGUAGE) and return false
        end

        # session language set and different. fix.
        if session[:lang] && sanitize_lang(session[:lang]) != lang && params[:set_lang].blank?
          logger.error "Lost locale #{session[:lang]} to #{lang} in #{complete_request_uri} from #{request.env['HTTP_REFERER']}"
          logger.info "redirecting to session locale #{session[:lang]}"
          redirect_to params.merge(:lang => session[:lang]) and return false
        end

        # unsupported. => redirect to default
        unless supported_lang?(lang)
          logger.debug "Unsupported lang #{params[:lang]}."
          logger.info "redirecting to default language #{DEFAULT_LANGUAGE}"
          redirect_to params.merge(:lang => DEFAULT_LANGUAGE) and return false
        end

        session[:lang] = lang
      end
    end
  end
end
