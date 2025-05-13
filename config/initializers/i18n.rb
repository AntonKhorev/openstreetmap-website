module I18n
  module Backend
    module PluralizationFallback
      def pluralize(locale, entry, count)
        super
      rescue InvalidPluralizationData => e
        raise e unless e.entry.key?(:other)

        e.entry[:other]
      end
    end
  end
end

module OpenStreetMap
  module I18n
    module NormaliseLocales
      def store_translations(locale, data, options = {})
        locale = ::I18n::Locale::Tag::Rfc4646.tag(locale).to_s

        super
      end
    end
  end
end

I18n::Backend::Simple.prepend(OpenStreetMap::I18n::NormaliseLocales)

I18n::Backend::Simple.include(I18n::Backend::PluralizationFallback)
I18n::Backend::Simple.include(I18n::Backend::Fallbacks)

I18n.enforce_available_locales = false

if Rails.env.test?
  I18n.exception_handler = proc do |exception|
    raise exception.to_exception
  end
end

Rails.configuration.after_initialize do
  require "i18n-js/listen"

  # This will only run in development.
  I18nJS.listen

  I18n.available_locales
end

AVAILABLE_LANGUAGES = Rails.root.glob("config/locales/*.yml").map do |filename|
  code = File.basename(filename, ".yml")
  native_name = case code
                when "en"
                  "English"
                when "en-GB"
                  "English (United Kingdom)"
                else
                  line = File.open(filename, &:readline)
                  line.match(/\(([^(]*\([^(]*\))\)$/) do |match_data|
                    match_data[1]
                  end || line.match(/\(([^(]*)\)$/) do |match_data|
                    match_data[1]
                  end || code
                end

  {
    :code => code,
    :native_name => native_name
  }
end

AVAILABLE_LANGUAGES.sort_by! do |entry|
  # https://stackoverflow.com/a/74029319
  diactrics = [*0x1DC0..0x1DFF, *0x0300..0x036F, *0xFE20..0xFE2F].pack("U*")
  entry[:native_name]
    .downcase
    .unicode_normalize(:nfd)
    .tr(diactrics, "")
    .unicode_normalize(:nfc)
end
