module ActionController

  # ROUTING: LANG DETECTION/GENERATION
  module Routing

    class Route
      include Astrails::Linguist::Helper
      def append_query_string_with_intl(path, hash, query_keys=nil)
        return nil unless path

        lang = hash.delete(:lang)

        url = append_query_string_without_intl(path, hash, query_keys)
        localize_path(url, lang)
      end
      alias_method_chain :append_query_string, :intl
    end

    class RouteSet
      # match /intl/LANG at the start of the url's path and set lang param
      LINGUIST_ROUTE_RE = /\/intl\/(#{SUPPORTED_LANGUAGES.join('|')})(\/.*$)/
      def recognize_path_with_intl(path, environment = {})
        lang = nil
        if path =~ LINGUIST_ROUTE_RE
          lang = $1
          path = $2
        end

        res = recognize_path_without_intl(path, environment)
        lang ? res.merge(:lang => lang) : res
      end
      alias_method_chain :recognize_path, :intl

      # FIXME: check if this one is still needed
      def generate_with_intl(options, recall = {}, method=:generate)
        options[:lang] ||= recall[:lang] if recall.has_key?(:lang) 

        generate_without_intl(options, recall, method)
      end
      alias_method_chain :generate, :intl
    end

    # patch generators for named routes to include language
    module Optimisation
      class PositionalArguments < Optimiser
        def lang_path_segment
          'GetText.locale.to_s == ::EMPTY_LANGUAGE ? "" : "/intl/#{GetText.locale.to_s}"'
        end
        def generation_code_with_intl
          generation_code_without_intl.gsub('if request.relative_url_root}',"if request.relative_url_root}\#{#{lang_path_segment}}")
        end
        alias_method_chain :generation_code, :intl
      end
    end
  end

  # URL_FOR
  class Base
    include Astrails::Linguist::Helper
    def url_for_with_intl(options = {}, *parameters_for_method_reference)
      options = localize_path(options) if options.is_a?(String)
      url_for_without_intl(options, *parameters_for_method_reference)
    end
    alias_method_chain :url_for, :intl
  end
end

# LINK_TO
module ActionView
  module Helpers
    module UrlHelper
      include Astrails::Linguist::Helper
      def link_to_with_intl(name, options = {}, html_options = nil, *parameters_for_method_reference)
        options = localize_path(options) if options.is_a?(String)
        link_to_without_intl(name, options, html_options, *parameters_for_method_reference)
      end
      alias_method_chain :link_to, :intl

      def url_for_with_intl(options = {})
        options = localize_path(options) if options.is_a?(String)
        url_for_without_intl(options)
      end
      alias_method_chain :url_for, :intl
    end

    module AssetTagHelper
      include Astrails::Linguist::Helper
      def image_path_with_intl(source)
        if (EMPTY_LANGUAGE != current_language) && (nil != source.index('.'))
          # we only localize images with extensions and only if current lang is not english
          local_source = source.split('.').insert(-2, current_language).join('.')
          source = local_source if File.exists?("#{RAILS_ROOT}/public/images/#{local_source}")
        end
        image_path_without_intl(source)
      end
      alias_method_chain :image_path, :intl
      alias_method :path_to_image, :image_path

      def stylesheet_path_with_intl(source)
        if EMPTY_LANGUAGE != current_language && File.exists?("#{RAILS_ROOT}/app/views/stylesheets/#{source.gsub(/\.css$/i, '')}.rcss")
          compute_public_path(source, "intl/#{current_language}/stylesheets", 'css')
        else
          stylesheet_path_without_intl(source)
        end
      end
      alias_method_chain :stylesheet_path, :intl
    end
  end
end
