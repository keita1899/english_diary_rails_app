module LoginSupport
  def sign_in_as(user)
    visit new_session_path

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end
