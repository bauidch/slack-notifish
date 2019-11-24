import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"

ApplicationWindow
{
    ConfigurationGroup {
        id: appSettings
        path: "/apps/slack-notify/settings"

        property string slackToken
        property bool onDuty: value("onDuty", true)
        property int checkIntervall: value("checkIntervall", 60)
        property bool useDefaultSound: value("useDefaultSound", true)
        property string customSoundPath
    }
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
