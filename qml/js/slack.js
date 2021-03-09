function httpGet(url) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false); // false for synchronous request
    xmlHttp.send(null);
    return xmlHttp;
}

function get_channel_name(token, chat_id, chat_type) {

    var channelInfo= httpGet("https://slack.com/api/conversations.info" + "?token=" + token + "&channel=" + chat_id  + "&unreads=true")
    try {
        var channelInfoJson = JSON.parse(channelInfo.responseText);
    } catch (erorr) {
        console.log("error: failed to parse ");
    }
    return channelInfoJson.channel.name
}

function get_unread(token, chat_id, chat_type) {

    var channelHistory = httpGet("https://slack.com/api/conversations.history" + "?token=" + token + "&channel=" + chat_id  + "&unreads=true")
    try {
        var channelHistoryJson = JSON.parse(channelHistory.responseText);
    } catch (erorr) {
        console.log("error: failed to parse ");
    }
    return channelHistoryJson.unread_count_display
}

function get_id(token, chat_name, chat_type) {
    var channelResponse
    switch(chat_type) {
        case "public":
            channelResponse = httpGet("https://slack.com/api/conversations.list" + "?token=" + token + "&types=public_channel")
        case "private":
            channelResponse = httpGet("https://slack.com/api/conversations.list" + "?token=" + token + "&types=private_channel")
    }
    try {
        var publicChannellJson = JSON.parse(channelResponse.responseText);
    } catch (erorr) {
        console.log("error: failed to parse ");
    }
    var publicChannelArray = [];
    for (var i = 0; i < publicChannellJson.channels.length; i++) {
        if (chat_name === publicChannellJson.channels[i].name) {
                  publicChannelArray.push({"name":publicChannellJson.channels[i].name, "channel_id": publicChannellJson.channels[i].id});
        }
    }
    return publicChannelArray
}

function get_channel_infos(token, chat_id, chat_type) {
    switch(chat_type) {
      case "public":
          var publicChatInfo = httpGet("https://slack.com/api/channels.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
          //console.log(publicChatInfo.responseText)
          try {
              var publicChatInfoJson = JSON.parse(publicChatInfo.responseText);
          } catch (e) {
              console.log("error: failed to parse");
          }
          //console.log(publicChatInfoJson)
          return publicChatInfoJson.channel.name
      case "private":
          var privatChannelInfo = httpGet("https://slack.com/api/groups.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
          //console.log(privatChannelInfo.responseText)
          try {
              var privatChannelInfoJson = JSON.parse(privatChannelInfo.responseText);
          } catch (error) {
              console.log("error: failed to parse ");
          }
          //console.log(privatChannelInfoJson)
          return privatChannelInfoJson.group.name
    }
}
