require 'test_helper'

class CurationMailerTest < ActionMailer::TestCase

  # FB: Need to do the following for full URL helpers to work properly
  include Rails.application.routes.url_helpers

  setup do
    @url_opts = Rails.application.routes.default_url_options
    Rails.application.routes.default_url_options = Rails.application.config.action_mailer.default_url_options
    @user = users(:unverified_user)
    @material = @user.materials.create!(title: 'Unverified Material',
                                        url: 'http://example.com/shady-event',
                                        description: '123',
                                        licence: 'Fair',
                                        doi: 'https://doi.org/10.1200/RSE.2020.123',
                                        keywords: ['unverified', 'user', 'material'],
                                        contact: 'main contact',
                                        status: 'active')
    # Avoids queued emails affecting `assert_email` counts. See: https://github.com/ElixirTeSS/TeSS/issues/719
    perform_enqueued_jobs
  end

  teardown do
    Rails.application.routes.default_url_options = @url_opts
  end

  test 'text user approval' do
    email = CurationMailer.user_requires_approval(@user)

    assert_emails 1 do
      email.deliver_now
    end

    admin_emails = User.with_role('admin').map(&:email)

    assert_equal [TeSS::Config.sender_email], email.from
    assert_equal admin_emails, email.to
    assert_equal "#{TeSS::Config.site['title_short']} user \"#{@user.name}\" requires approval", email.subject

    body = email.text_part.body.to_s

    assert body.include?(@material.title), 'Expected material title to appear in email body'
    assert body.include?(material_url(@material)), 'Expected TeSS material URL to appear in email body'
    assert body.include?(@material.url), 'Expected material URL to appear in email body'

    assert body.include?(curate_users_url), 'Expected curation link'
  end

  test 'html user approval' do
    email = CurationMailer.user_requires_approval(@user)

    assert_emails 1 do
      email.deliver_now
    end

    admin_emails = User.with_role('admin').map(&:email)

    assert_equal [TeSS::Config.sender_email], email.from
    assert_equal admin_emails, email.to
    assert_equal "#{TeSS::Config.site['title_short']} user \"#{@user.name}\" requires approval", email.subject

    html = email.html_part.body.to_s

    assert html.include?(@material.title), 'Expected material title to appear in email body'
    assert html.include?(material_url(@material)), 'Expected TeSS material URL to appear in email body'
    assert html.include?(@material.url), 'Expected material URL to appear in email body'

    assert html.include?(curate_users_url), 'Expected curation link'
  end

  test 'can set mailer headers in config' do
    mailer_settings = TeSS::Config.mailer
    TeSS::Config.mailer['headers'] = { 'Sender' => 'mail.sender@example.com', 'X-Something' => 'yes' }
    email = CurationMailer.user_requires_approval(@user)

    email_headers = {}
    email.header.fields.each { |f| email_headers[f.name] = f.value }

    assert_equal 'no-reply@example.com', email_headers['From']
    assert_equal 'mail.sender@example.com', email_headers['Sender']
    assert_equal 'yes', email_headers['X-Something']
  ensure
    TeSS::Config.mailer = mailer_settings
  end
end
