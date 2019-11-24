import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.6
import Nemo.Notifications 1.0

import "../js/slack.js" as Slack

Page {
    id: mainPage
    property string notificationChannel
    property int unreadCount
    property string leSlackToken: ""
    property variant privateChannels: ['','', '']
    property variant publicChannels: ['', '']
    property string defaultNotificationSound: Qt.resolvedUrl("../sounds/slack-notification.wav")

    allowedOrientations: Orientation.All


    SoundEffect {
        id: alertSound
        volume: 0.6
        source: "slack-notification.wav"
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
            for (var i = 0; i < mainPage.publicChannels.length; i++) {
                if(Slack.get_unread_private(mainPage.leSlackToken, mainPage.privateChannels[i]) > 0) {
                    alertSound.play()
                    mainPage.notificationChannel = Slack.get_private_channel_info(mainPage.leSlackToken, mainPage.privateChannels[i])
                    mainPage.unreadCount = Slack.get_unread_private(mainPage.leSlackToken,mainPage.privateChannels[i])
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

            SectionHeader { text: qsTr("Public Channels") }
            ColumnView {
                 model: publicListModel
                 itemHeight: Theme.itemSizeSmall

                 delegate: ListItem {
                      Label {
                        text: "#" + model.name
                        font.pixelSize: Theme.fontSizeMedium
                        width: parent.width
                        color: Theme.primaryColor
                        horizontalAlignment: Text.AlignLeft
                        x: Theme.paddingMedium
                      }

                      Label {
                        text: model.channel_id
                        font.pixelSize: Theme.fontSizeMedium
                        width: parent.width
                        color: Theme.secondaryColor
                        horizontalAlignment: Text.AlignRight
                        x: Theme.paddingMedium
                      }
                 }
            }

            SectionHeader { text: qsTr("Private Channels") }
            ColumnView {
                 model: privateListModel
                 itemHeight: Theme.itemSizeSmall

                 delegate: ListItem {
                          Label {
                            text: "#" + model.name
                            font.pixelSize: Theme.fontSizeMedium
                            width: parent.width
                            horizontalAlignment: Text.AlignLeft
                            color: Theme.primaryColor
                            x: Theme.paddingMedium
                          }
                          Label {
                            text: model.channel_id
                            font.pixelSize: Theme.fontSizeMedium
                            width: parent.width
                            color: Theme.secondaryColor
                            horizontalAlignment: Text.AlignRight
                            x: Theme.paddingMedium
                          }
                 }
            }

        }
    }

    ListModel {
        id: privateListModel
    }
    ListModel {
        id: publicListModel
    }
    Component.onCompleted: {
        for (var i = 0; i < mainPage.privateChannels.length; i++) {
            privateListModel.append({"name":Slack.get_private_channel_info(mainPage.leSlackToken, mainPage.privateChannels[i]), "channel_id":mainPage.privateChannels[i]})
        }
        for (var d = 0; d < mainPage.publicChannels.length; d++) {
            publicListModel.append({"name":Slack.get_public_channel_info(mainPage.leSlackToken, mainPage.publicChannels[d]), "channel_id":mainPage.publicChannels[d]})
        }
    }
}


