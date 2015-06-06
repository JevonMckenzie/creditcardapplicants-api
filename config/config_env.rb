config_env :development, :test do
  set 'DB_KEY', "Nwd8cHES5TXtyT5ORZt2jVsy20QixbNziQzmq37IXjA="
  set 'MSG_KEY', "nOpFj9VM3XD4uYsWxnFx2HZr3MSizc_5pxmwzgy6s9s="
end

config_env :production do
  set 'DB_KEY', "7Qbi3XJcok2WinTPRgr5t4l42L8wvrh0ElrLi5Z3qdI="
  set 'MSG_KEY', "0pY2VsiUswep2smKNlk-kqXTqKKLwXc_1yYL5lM0TT8="
end

config_env do
  set 'SENDGRID_DOMAIN', 'heroku.com'
  set 'SENDGRID_USERNAME', 'app37068920@heroku.com'
  set 'SENDGRID_PASSWORD', 'bvlf6ude7064'
end
