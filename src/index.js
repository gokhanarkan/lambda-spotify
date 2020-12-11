const { getNowPlaying, getRecentlyPlayed, simplifyData } = require("./spotify");

exports.handler = async (event) => {
  const requestBody = event.queryStringParameters;

  if (
    !requestBody.preference ||
    (requestBody.preference !== "nowPlaying" &&
      requestBody.preference !== "mostRecent")
  ) {
    return {
      success: false,
      msg: "Invalid preference.",
    };
  }

  if (requestBody.preference === "nowPlaying") {
    const response = await getNowPlaying();
    if (response.status === 204 || response.status > 400) {
      return {
        success: false,
      };
    }

    const song = await response.json();
    const data = await simplifyData(song.item);

    return {
      success: true,
      data,
    };
  }

  // else most recent song
  const response = await getRecentlyPlayed();
  if (response.status !== 200) {
    return {
      success: false,
    };
  }

  const song = await response.json();
  const data = await simplifyData(song.items[0].track);

  return {
    success: true,
    data,
  };
};
