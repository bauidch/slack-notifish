import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"
import "components"

ApplicationWindow
{
    ConfigurationGroup {
        id: appSettings
        path: "/apps/slack-notify/settings"

        property string slackToken
        property bool onDuty: true
        property int checkIntervall:60
        property bool useDefaultSound: true
        property bool vibration: false
        property string customSoundPath
    }
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        loadChannelsFromStorage()
    }

    Storage {
        id: channelStorage
    }
    ListModel {
        id: channelsModel
    }

    function loadChannelsFromStorage() {
        var channels = channelStorage.getChannels()
        for (var i = 0; i < channels.length; ++i) {
            channelsModel.append(
            {
                name: channels[i].name,
                channel_id: channels[i].channel_id,
                type: channels[i].type
            }
            )
       }
    }
    function saveChannelsToStorage() {
        var channels = []

        for (var i = 0; i < channelsModel.count; ++i) {
            var channel = channelsModel.get(i)
            channels.push({
                name:channel.name,
                channel_id: channel.channel_id,
                type:channel.type
            })
        }

        channelStorage.saveChannels(channels)
    }

    function reloadChannels() {
        channelsModel.clear()
        loadChannelsFromStorage()
    }
}
