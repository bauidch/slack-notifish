# slack-notifish
Slack Notifications for SailfishOS

## Description
This is a simply app for informs you, about an unread Slack message.

### Features
- Show count of unread messages
- Notification when unread Messages
- Add Slack Channels

## Slack Token
Add a Slack App in your Workspace. (https://api.slack.com/apps)
Your app should have the following rights
- channels:history
- channels:read
- groups:history
- groups:read

Copy your OAuth Access Token to the slack token section in settings of the app.

# Credits

## ToDo/ Ideas
- Use own Slack token inkl. Tests
- Use new Slack API  
- Better Error Handling  
- Vibration
- UI
  - Sort Function
  - Better Cover
- Settings  
    - Select own Notification sound
    - Test Notification
    - Test Alert Sound
- Release App in OpenRepos and Jolla Store
- Background Job
- Delete Configuration option
- Translation
- Duty Time Range
- Update QtQuick
