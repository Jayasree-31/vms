object @user
attributes :name, :email, :mobile
node(:id) {|c| c.id.to_s }
node(:access_token) {@access_token.token}
node(:refresh_token) {@access_token.refresh_token}
node(:expires_in) {@access_token.expires_in}
