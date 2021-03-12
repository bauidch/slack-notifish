import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.6
import Nemo.Notifications 1.0
import QtFeedback 5.0
import "../components"
import "../js/slack.js" as Slack

Page {
    id: mainPage
    property string notificationChannel
    property int unreadCount
    property string inlineSlackToken: ""
    property string defaultNotificationSound: Qt.resolvedUrl("../sounds/slack-notification.wav")

    allowedOrientations: Orientation.All

    SoundEffect {
        id: alertSound
        volume: 0.6
        source: "slack-notification.wav"
    }
    HapticsEffect {
        id: alertVibration
        duration: 500
        intensity: 0.2
        running: appSettings.vibration
    }

    Notification {
        id: notification
        appName: "Slack Notification"
        category: "x-nemo.messaging"
        summary: qsTr("New Mesage in") +" "+ mainPage.notificationChannel
        body:  mainPage.unreadCount +" "+ qsTr("new message in channel") +" "+ mainPage.notificationChannel
        previewSummary: summary
        previewBody: body
        urgency: Notification.Critical
        function republish() {
            publish()
        }
    }
    Timer {
        id: alertTimer
        interval: appSettings.checkIntervall * 1000 // sec -> msec
        running: appSettings.onDuty
        repeat: true
        onTriggered: {
            for (var i = 0; i < channelsModel.count; ++i) {
                var channel = channelsModel.get(i)
                var unreadMessages = Slack.get_unread(mainPage.inlineSlackToken, channel.channel_id, channel.type)
                if( unreadMessages > 0) {
                    alertSound.play()
                    alertVibration.start()
                    mainPage.notificationChannel = channel.name
                    mainPage.unreadCount = unreadMessages
                    notification.republish()
                }
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: mainPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Slack Notifish")
            }

            SectionHeader { text: qsTr("Channels") }
            ColumnView {
                 model: channelsModel
                 itemHeight: Theme.itemSizeSmall

                 delegate: ListItem {
                     onClicked: {
                        pageStack.push(Qt.resolvedUrl('ChannelInfo.qml'), {channelID: model.channel_id, channelName: model.name, channelType: model.type})
                     }
                     Row {
                         id: row
                         anchors.verticalCenter: parent.verticalCenter
                         x: Theme.paddingSmall * (Screen.sizeCategory >= Screen.Small ? 2 : 1)
                         spacing: Theme.paddingSmall
                     IconButton {
                        icon.source: setChannelIcon()
                        anchors.verticalCenter: parent.verticalCenter
                        function setChannelIcon()
                        {
                            var imageIcon
                            if(model.type === "public")
                            {
                                imageIcon = "image://theme/icon-m-chat"
                            }
                            if(model.type === "private")
                            {
                                imageIcon = "image://theme/icon-m-device-lock"
                            }
                            return imageIcon
                        }
                     }
                          Label {
                            text: "#" + model.name
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.primaryColor
                          }
                          Label {
                            text: model.channel_id
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.secondaryColor
                          }
                     }
                 }
            }
            Repeater {
                model: [
                    qsTr("No Channels, go to settings")
                ]
                Label {
                  id: infoViewLabel
                  text: modelData
                  font.pixelSize: Theme.fontSizeSmall
                  x: Theme.paddingLarge
                  wrapMode: Text.Wrap
                  color: Theme.secondaryColor
                  visible: checkChannels()
                  function checkChannels() {
                      if(channelsModel.count == 0) {
                        return true
                      } else {
                        return false
                      }
                  }
                }
            }

        }

    }
}
