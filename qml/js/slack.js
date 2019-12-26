function httpGet(url) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false); // false for synchronous request
    xmlHttp.send(null);
    return xmlHttp;
}

//function get_public_channels(token) {
//    var publicChannel = httpGet("https://slack.com/api/channels.list" + "?token=" + token + "&exclude_archived=true&exclude_members=true&pretty=1")

//    console.log(publicChannel.responseText)
//    try {
//        var publicChannellJson = JSON.parse(publicChannel.responseText);
//    } catch (e) {
//        console.log("error: failed to parse ");
//    }
//    console.log(publicChannellJson.channels.length)
//    for (var i = 0; i < publicChannellJson.channels.length; i++) {
//        console.log(publicChannellJson.channels[i].name +" "+ publicChannellJson.channels[i].id);
//    }
//    return publicChannellJson
//}

//function get_public_channel_info(token, chat_id) {
//    var publicChatInfo = httpGet("https://slack.com/api/channels.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
//    try {
//        var publicChatInfoJson = JSON.parse(publicChatInfo.responseText);
//    } catch (e) {
//        console.log("error: failed to parse");
//    }
//    return publicChatInfoJson.channel.name
//}

//function get_unread_public(token, chat_id) {
//    var publicChatInfo = httpGet("https://slack.com/api/channels.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
//    try {
//        var privatChatJson = JSON.parse(publicChatInfo.responseText);
//    } catch (e) {
//        console.log("error: failed to parse");
//    }
//    return privatChatJson.channel.unread_count_display
//}

//function get_private_channels(token) {
//    var privatChannel = httpGet("https://slack.com/api/groups.list" + "?token=" + token + "&types=private_channel")

//    try {
//        var privatChannelJson = JSON.parse(privatChannel.responseText);
//    } catch (e) {
//        console.log("error: failed to parse ");
//    }
//    return privatChannelJson
//}

//function get_unread_private(token, chat_id) {
//    var privatChannelInfo = httpGet("https://slack.com/api/groups.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
//    try {
//        var privatChannelInfoJson = JSON.parse(privatChannelInfo.responseText);
//    } catch (e) {
//        console.log("error: failed to parse ");
//    }
//    return privatChannelInfoJson.group.unread_count_display
//}

//function get_private_channel_info(token, chat_id) {
//    var privatChannelInfo = httpGet("https://slack.com/api/groups.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
//    try {
//        var privatChannelInfoJson = JSON.parse(privatChannelInfo.responseText);
//    } catch (e) {
//        console.log("error: failed to parse ");
//    }
//    return privatChannelInfoJson.group.name
//}
// @TODO use case to seperate public and private channel

function get_channel_name(token, chat_id, chat_type) {
    switch(chat_type) {
      case "public":
          var publicChatInfo = httpGet("https://slack.com/api/channels.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
          try {
              var publicChatInfoJson = JSON.parse(publicChatInfo.responseText);
          } catch (e) {
              console.log("error: failed to parse");
          }
          return publicChatInfoJson.channel.name
      case "private":
          var privatChannelInfo = httpGet("https://slack.com/api/groups.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
          try {
              var privatChannelInfoJson = JSON.parse(privatChannelInfo.responseText);
          } catch (error) {
              console.log("error: failed to parse ");
          }
          return privatChannelInfoJson.group.name
    }
}

function get_unread(token, chat_id, chat_type) {
    switch(chat_type) {
      case "public":
          var publicChatInfo = httpGet("https://slack.com/api/channels.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
          try {
              var privatChatJson = JSON.parse(publicChatInfo.responseText);
          } catch (e) {
              console.log("error: failed to parse");
          }
          return privatChatJson.channel.unread_count_display
      case "private":
          var privatChannelInfo = httpGet("https://slack.com/api/groups.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
          try {
              var privatChannelInfoJson = JSON.parse(privatChannelInfo.responseText);
          } catch (erorr) {
              console.log("error: failed to parse ");
          }
          return privatChannelInfoJson.group.unread_count_display
    }
}

function get_id(token, name, chat_type) {
    switch(chat_type) {
      case "public":
          var publicChannel = httpGet("https://slack.com/api/channels.list" + "?token=" + token + "&exclude_archived=true&exclude_members=true&pretty=1")

          try {
              var publicChannellJson = JSON.parse(publicChannel.responseText);
          } catch (e) {
              console.log("error: failed to parse ");
          }
          var publicChannelArray = [];
          for (var i = 0; i < publicChannellJson.channels.length; i++) {
              if (name === publicChannellJson.channels[i].name) {
                  publicChannelArray.push({"name":publicChannellJson.channels[i].name, "channel_id": publicChannellJson.channels[i].id});
              }
          }
          return publicChannelArray
      case "private":
          var privateChannel = httpGet("https://slack.com/api/groups.list" + "?token=" + token + "&types=private_channel")
          try {
              var privateChannelJson = JSON.parse(privateChannel.responseText);
          } catch (er) {
              console.log("error: failed to parse ");
          }
          var channel = [];
          for (var d = 0; d < privateChannelJson.groups.length; d++) {
              if (name === privateChannelJson.groups[d].name) {
                  channel.push({"name":privateChannelJson.groups[d].name, "channel_id": privateChannelJson.groups[d].id});
              }
          }
          return channel
    }
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
