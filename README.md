# lambda-spotify

Inspired by [leerob.io](https://leerob.io/), this is the updated & modified version for getting current playing or the most recently played song from Spotify via AWS Lambda function.

## Instructions

### Create App on Spotify

Create an app from [Spotify Developer Dashboard](https://developer.spotify.com/dashboard). Add `http://localhost:4567` as the redirect URI to the app settings.

### Generate Refresh Token

For apps that use the Spotify API, users are required to login once every 60 minutes. This can be resolved by implementing the Authorization Code Flow and getting a refresh token. Using this flow requires that you set up your own server that performs a token swap and refresh.

![Spotify Authorization Flow](https://developer.spotify.com/assets/AuthG_AuthoriztionCode.png)

I have listed two ways to generate this token. The refresh tokens never expire unless the user revokes it.

#### 1. Hard Way

Authenticate your application with the app's client id. The client id and client secret can be retrieved from the Spotify Developer Dashboard at any time.

```
https://accounts.spotify.com/authorize?client_id={CLIENT_ID}&response_type=code&redirect_uri=http
%3A%2F%2Flocalhost:4567&scope=user-read-currently-playing%20
user-top-read%20user-read-recently-played
```

Save the value of the code parameter.

Generate Base 64 encoded string with the following keys: `client_id:client_secret`

Post the info to Spotify. Example:

```javascript
axios.post({
  url: "https://accounts.spotify.com/api/token",
  headers: {
    Authorization: "Basic {base64 encoded client_id:client_secret}",
    "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
  },
  data:
    "grant_type=authorization_code&code={AUTH_CODE}&redirect_uri=http%3A%2F%2Flocalhost%3A4567",
});
```

#### 2. Easy way

I've created an automated script `refresh_token.rb` within the `./scripts/` directory. It's a terminal-based application where you can input the required info and retrieve the necessary token.

Ruby not installed on your machine? [Here I added this to repl.it.](https://repl.it/@gokh/spotifyrefreshtoken#main.rb)

## Demo

I am using URL Params to identify whether I am currently playing a song or request the most recent music I played.

The URL below gives the current song I am playing, if I am, of course! Otherwise, it will return false.

[https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=nowPlaying](https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=nowPlaying)

This one, on the other hand, will give the most recent piece.

[https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=mostRecent](https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=mostRecent)
