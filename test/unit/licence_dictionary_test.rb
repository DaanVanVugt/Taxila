require 'test_helper'

class LicenceDictionaryTest < ActiveSupport::TestCase

  test "singleton" do
    dic = LicenceDictionary.instance
    assert dic.is_a?(LicenceDictionary)

    dic2 = LicenceDictionary.instance
    assert_same dic, dic2

    assert_raise NoMethodError do
      LicenceDictionary.new
    end
  end

  test "licences dictionary exists" do
    dic = LicenceDictionary.instance
    assert_not_nil dic, "licence dictionary should exist"
    assert_not dic.licence_names.blank?, "licence dictionary should not be empty"
  end

  test "licence values exist" do
    dic = LicenceDictionary.instance
    assert (dic.licence_abbreviations.include? "Apache-2.0"),
           "'Apache-2.0' should be among the licence abbreviations"
    assert_not (dic.licence_abbreviations.include? "licence_that_will_never_exist"),
           "'licence_that_will_never_exist' should not be among licences"
    assert (dic.licence_names.include? "Apache License 2.0"),
           "'Apache License 2.0' should be among the licence names"
    assert_includes dic.lookup("Apache-2.0")['see_also'], "http://www.opensource.org/licenses/Apache-2.0",
                 "'http://www.opensource.org/licenses/Apache-2.0' should be among the licence URLs"

  end

end