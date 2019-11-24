import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: settingsDialog

    SilicaFlickable {
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
                EnterKey.onClicked: parent.focus = true;
            }

            SectionHeader { text: qsTr("Notifications") }

            TextSwitch {
                id: onDutyToggle
                text: qsTr("On Duty")
                checked: appSettings.onDuty
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
        }


    }

    allowedOrientations: defaultAllowedOrientations
    onAccepted:{
        appSettings.setValue("onDuty", onDutyToggle.checked)
        appSettings.setValue("slackToken", slackTokenField.text)
        appSettings.setValue("checkIntervall", intervallSlider.value)

    }
}
