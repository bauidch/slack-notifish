# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = slack-notifish

CONFIG += sailfishapp

SOURCES += src/slack-notifish.cpp

DISTFILES += qml/slack-notifish.qml \
    qml/cover/CoverPage.qml \
    qml/js/slack.js \
    qml/pages/AboutPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingsPage.qml \
    rpm/slack-notifish.changes.in \
    rpm/slack-notifish.changes.run.in \
    rpm/slack-notifish.spec \
    rpm/slack-notifish.yaml \
    translations/*.ts \
    slack-notifish.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/slack-notifish-de.ts
