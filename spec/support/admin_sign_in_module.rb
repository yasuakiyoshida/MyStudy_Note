module AdminSignInModule
  def admin_sign_in_as(admin)
    visit new_admin_session_path
    fill_in "メールアドレス", with: admin.email
    fill_in "パスワード", with: admin.password
    click_button "ログインする"
  end
end
