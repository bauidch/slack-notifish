function httpGet(url) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", url, false); // false for synchronous request
    xmlHttp.send(null);
    return xmlHttp;
}

function get_public_channels(token) {
    var publicChannel = httpGet("https://slack.com/api/channels.list" + "?token=" + token + "&exclude_archived=true&exclude_members=true&pretty=1")

    try {
        var publicChannellJson = JSON.parse(publicChannel.responseText);
    } catch (e) {
        console.log("error: failed to parse ");
    }
    return publicChannellJson
}

function get_public_channel_info(token, chat_id) {
    var publicChatInfo = httpGet("https://slack.com/api/channels.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
    try {
        var publicChatInfoJson = JSON.parse(publicChatInfo.responseText);
    } catch (e) {
        console.log("error: failed to parse");
    }
    return publicChatInfoJson.channel.name
}

function get_unread_public(token, chat_id) {
    var publicChatInfo = httpGet("https://slack.com/api/channels.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
    try {
        var privatChatJson = JSON.parse(publicChatInfo.responseText);
    } catch (e) {
        console.log("error: failed to parse");
    }
    return privatChatJson.channel.unread_count_display
}

function get_private_channels(token) {
    var privatChannel = httpGet("https://slack.com/api/groups.list" + "?token=" + token + "&types=private_channel")

    try {
        var privatChannelJson = JSON.parse(privatChannel.responseText);
    } catch (e) {
        console.log("error: failed to parse ");
    }
    return privatChannelJson
}

function get_unread_private(token, chat_id) {
    var privatChannelInfo = httpGet("https://slack.com/api/groups.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
    try {
        var privatChannelInfoJson = JSON.parse(privatChannelInfo.responseText);
    } catch (e) {
        console.log("error: failed to parse ");
    }
    return privatChannelInfoJson.group.unread_count_display
}

function get_private_channel_info(token, chat_id) {
    var privatChannelInfo = httpGet("https://slack.com/api/groups.info" + "?token=" + token + "&channel=" + chat_id  + "&pretty=1")
    try {
        var privatChannelInfoJson = JSON.parse(privatChannelInfo.responseText);
    } catch (e) {
        console.log("error: failed to parse ");
    }
    return privatChannelInfoJson.group.name
}


