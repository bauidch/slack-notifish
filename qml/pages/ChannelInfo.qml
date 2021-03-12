import QtQuick 2.6
import Sailfish.Silica 1.0
import "../js/slack.js" as Slack

Page {
    id: channelInfo
    property string channelID
    property string channelName
    property string channelType
    property variant channelDetails
    property string inlineSlackToken: ""

   SilicaFlickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: channelInfo.width
            spacing: Theme.paddingLarge


            PageHeader {
                title: "#" + channelInfo.channelName
            }
            SectionHeader { text: qsTr("Infos") }
            Label {
                text: qsTr("ID: ") + channelInfo.channelID
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                x: 50
            }
            Label {
                text: qsTr("Type: ") + channelInfo.channelType
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                x: 50
            }
            SectionHeader { text: qsTr("Messages") }
            Label {
                id: unreadLabel
                text: qsTr("Unread: ") + 42
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                x: 50
            }
        }
    }
   Component.onCompleted: {
       unreadLabel.text = qsTr("Unread: ") + Slack.get_unread(channelInfo.inlineSlackToken, channelInfo.channelID, channelInfo.channelType)

   }
}
