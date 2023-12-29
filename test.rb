require "i18n"

require "rails/all"

ENV["RAILS_ENV"] = "test"

require "active_support/dependencies/autoload"

class Test < TLDR
  def test_one
    require "action_view/base"
  end

  def test_two
    require "action_view/base"
  end

  def test_three
    klass = Class.new do
      include ActionView::Helpers::TranslationHelper
    end

    klass.new.t("three")
  end

  def test_four
    klass = Class.new do
      include ActionView::Helpers::TranslationHelper
    end

    klass.new.t("four")
  end
end
