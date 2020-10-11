module LoginMacros
  def login(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
  end

  def logout
    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました。'
  end
end

module WaitForAjax
  def wait_for_ajax(wait_time = 4)
    Timeout.timeout(wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

RSpec.configure do |config|
  config.include LoginMacros, type: :system
  config.include WaitForAjax, type: :system
end
