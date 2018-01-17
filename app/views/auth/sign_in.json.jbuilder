json.session do
  json.partial! 'sessions/self_session', session: @session
end
json.user do
  json.partial! 'users/self', user: @session.user
end