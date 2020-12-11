# lambda-spotify

Lambda Function to display (the most recent song || now playing song) from Spotify

Inspired by [leerob.io](https://leerob.io/), this is the updated & modified version for getting currently playing or the most recently played song from Spotify via AWS Lambda function.

# Instructions

1. Create an app from Spotify Developer Dashboard.
2. Authenticate your application with the client id.

```
https://accounts.spotify.com/authorize?client_id={CLIENT_ID}&response_type=code&redirect_uri=http
%3A%2F%2Flocalhost:3000&scope=user-read-currently-playing%20
user-top-read%20user-read-recently-played
```

3. Get a refresh token for unlimited queries.

```javascript
axios.post({
  url: "https://accounts.spotify.com/api/token",
  headers: {
    Authorization: "Basic {base64 encoded client_id:client_secret}",
    "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
  },
  data:
    "grant_type=authorization_code&code={AUTH_CODE}&redirect_uri=http%3A%2F%2Flocalhost%3A3000",
});
```

# Demo

I am using URL Params to identify whether I am currently playing a song or request the most recent music I played.

The URL below gives the current song I am playing, if I am, of course!

[https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=nowPlaying](https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=nowPlaying)

This one, on the other hand, will give the most recent piece.

[https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=mostRecent](https://4tiumvx0uh.execute-api.eu-west-2.amazonaws.com/what-im-listening?preference=mostRecent)
