import QtQuick 2.6
import Sailfish.Silica 1.0
import "../components"
import "../js/slack.js" as Slack

Dialog {
    id: settingsDialog
    property variant channelInfo
    property string inlineSlackToken: ""

    SilicaFlickable {
        id: pageFlickable
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        DialogHeader {
            id: header
            acceptText: qsTr("Save")
            cancelText: qsTr("Cancel")
        }

        Column {
            id: column
            width: settingsDialog.width
            spacing: Theme.paddingLarge

            DialogHeader {
                title: qsTr("Settings")
            }

            PasswordField {
                id: slackTokenField
                width: parent.width
                label: qsTr("Slack Token")
                text: appSettings.slackToken
                placeholderText: qsTr("Slack Token")
                EnterKey.onClicked: parent.focus = true;
            }

            SectionHeader { text: qsTr("Notifications") }

            IconTextSwitch {
                id: onDutyToggle
                text: qsTr("On Duty")
                checked: appSettings.onDuty
                icon.source: "image://theme/icon-m-alarm"
            }
            IconTextSwitch {
                id: vibrationToggle
                checked: appSettings.vibration
                text: qsTrId("Vibration")
                icon.source: "image://theme/icon-m-vibration"
            }

            Slider {
                id: intervallSlider
                width: parent.width
                label: qsTr("Notification interval")
                minimumValue: 30
                maximumValue: 600
                stepSize: 10
                value: appSettings.checkIntervall
                valueText: Math.floor(value / 60) + (value % 60 < 10 ? ":0" + value % 60 : ":" + value % 60)
            }
            SectionHeader { text: qsTr("Channels") }
            ColumnView {
                 model: channelsModel
                 itemHeight: Theme.itemSizeLarge

                 delegate: ListItem {
                     id: channelItem
                     ListView.onRemove: animateRemoval(channelItem)

                     function remove() {
                         remorseAction(qsTr("Deleting"), function() {
                             channelsModel.remove(index)
                         });
                     }

                     TextField {
                        id: channelNameInput
                        width: font.pixelSize * 10
                        text: model.name
                        placeholderText: qsTr("Channelname")
                        label: qsTr("name")
                        errorHighlight: false
                        EnterKey.onClicked: {
                            parent.focus = true;
                            label = qsTr("name");
                        }
                        onFocusChanged: {
                            if(text.length > 0) {
                                if( settingsDialog.validateChannel(index, text, model.type)) {
                                    channelsModel.setProperty(index, "name",  text)
                                    errorHighlight = false
                                    label = qsTr("name")
                                } else {
                                    errorHighlight = true
                                    label = qsTr("Channel not found")
                                }
                            }
                        }
                     }
                     TextField {
                        id: channelTypeInput
                        width: font.pixelSize * 5
                        text: model.type
                        placeholderText: qsTr("Type")
                        anchors.left: channelNameInput.right
                        label: qsTr("type")
                        errorHighlight: false
                        EnterKey.onClicked: parent.focus = true;
                        onFocusChanged:  {
                            if(text.length > 0) {
                                channelsModel.setProperty(index, "type",  text)
                            }
                            if(text != "private" || text != "public") {
                               errorHighlight = true
                            }
                        }
                     }
                     IconButton {
                        anchors.left: channelTypeInput.right
                        icon.source: "image://theme/icon-m-clear"
                        onClicked: remove()
                        x: Theme.paddingMedium
                     }
                 }
            }
            Button {
                id: addPrivateChannelButton
                text: "Add new Channel"
                width: parent.width
                onClicked: {
                    channelsModel.append({
                        name: qsTr("New"),
                        channel_id: "ABCDEFGHI",
                        type: "public"
                    })
               }
            }

        }

    }

    allowedOrientations: defaultAllowedOrientations
    VerticalScrollDecorator {
        flickable: pageFlickable
    }
    onAccepted:{
        appSettings.setValue("onDuty", onDutyToggle.checked)
        appSettings.setValue("slackToken", slackTokenField.text)
        appSettings.setValue("checkIntervall", intervallSlider.value)
        appSettings.setValue("vibration", vibrationToggle.checked)
        saveChannelsToStorage()
    }
    onRejected: reloadChannels()

    function validateChannel(idx, imputName, type) {
        settingsDialog.channelInfo = Slack.get_id(settingsDialog.inlineSlackToken, imputName, type)
        if(settingsDialog.channelInfo.length > 0) {
            channelsModel.setProperty(idx, "channel_id", settingsDialog.channelInfo[0].channel_id)
            console.log(settingsDialog.channelInfo[0].channel_id + " : " + settingsDialog.channelInfo[0].name)
            return true;
        } else {
            return false;
        }
    }
}
