module AuthorizationHelper
  include ActionView::Helpers::TranslationHelper

  def authorization_scope(scope)
    html = []
    if scope == "write_blocks"
      html << image_tag("roles/moderator.png", :srcset => image_path("roles/moderator.svg", :class => "align-text-bottom"), :size => "20x20")
      html << " "
    end
    html << t("oauth.scopes.#{scope}")
    safe_join(html)
  end
end
