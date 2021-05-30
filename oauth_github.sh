export CLIENT_ID=
export CLIENT_SECRET=


export REDIRECT_URI=http%3A%2F%2Flocalhost%3A3000%2Fapi%2Fv1%2Ftodo-lists # values have to be URL encoded
export LOGIN=francesco-losciale
export SCOPE=user
export STATE=any-value-for-CSRF

# 1 - pass authorization parameters and GET code
curl \
  -X GET https://github.com/login/oauth/authorize\?client_id\=$(CLIENT_ID)\&redirect_uri\=$(REDIRECT_URI)\&login\=$(LOGIN)\&scope\=$(SCOPE)\&state\=$(STATE)

# returns an html with redirect uri + `?code=$(CODE)&state=$(STATE)`

export CODE=



# 2 - Use $(CODE) to get an access token

curl \
-X POST https://github.com/login/oauth/access_token \
-H "Content-Type: application/json" \
--data '{"code":"$(CODE)","client_id":"$(CLIENT_ID)","client_secret":"$(CLIENT_SECRET)","redirect_uri":"http://localhost:3000/api/v1/todo-lists"}'

# response body will be something like 
# `access_token=$(ACCESS_TOKEN)&scope=user&token_type=bearer`



# 3 - test using user api

# curl -H "Authorization: Bearer <TOKEN>" https://api.github.com/user




### Server side, the resource service has to validate the token against the authorization URI...

# https://docs.github.com/en/rest/reference/apps#check-a-token

curl \
  -u "$(CLIENT_ID):$(CLIENT_SECRET)" \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/applications/$(CLIENT_ID)/token \
  -d '{"access_token":"$(ACCESS_TOKEN)"}'
  
# returns a payload with all information about the check  or BAD request
