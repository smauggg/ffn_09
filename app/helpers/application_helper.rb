module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title page_title = ""
    base_title = I18n.t("main_title")
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # Return the col-xx-x for views
  def css_col_for_partial counter
    counter.zero? ? 8 : 4
  end
end
