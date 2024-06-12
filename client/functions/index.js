const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnNewMessage = functions.firestore
    .document('messages/{messageId}')
    .onCreate((snapshot, context) => {
        const message = snapshot.data();
        const payload = {
            notification: {
                title: 'New Message',
                body: message.content,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        return admin.messaging().sendToTopic('chat_' + message.roomId, payload);
    });
