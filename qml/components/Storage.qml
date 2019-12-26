import QtQuick 2.0
import QtQuick.LocalStorage 2.0

ListModel {
     id: model

     function __db()
     {
         return LocalStorage.openDatabaseSync("Slacknotifish", "1.0", "The Local Channel Storage", 1000);
     }
     function __ensureTables(tx)
     {
         tx.executeSql('CREATE TABLE IF NOT EXISTS channels(name TEXT, channel_id TEXT, type TEXT, PRIMARY KEY(name))', []);
     }

//     function fillModel() {
//         __db().transaction(
//             function(tx) {
//                 __ensureTables(tx);
//                 var rs = tx.executeSql("SELECT name, channel_id, type FROM channels ORDER BY name DESC", []);
//                 model.clear();
//                 if (rs.rows.length > 0) {
//                     for (var i=0; i<rs.rows.length; ++i) {
//                         var row = rs.rows.item(i);
//                         model.append({"name":row.name,"channel_id":row.channel_id,"type":row.type})
//                     }
//                 }
//             }
//         )
//     }
     function getChannels() {
         var channels = [];
         __db().transaction(
             function(tx) {
                 __ensureTables(tx);
                 try {
                    var rs = tx.executeSql("SELECT * FROM channels", []);
                 }
                 catch(e) {
                    if(e.code === SQLException.DATABASE_ERR) {
                        console.warn('Database error:', e.message);
                    } else if(e.code === SQLException.SYNTAX_ERR) {
                        console.warn('Database version error:', e.message);
                    } else {
                        console.warn('Database unknown error:', e.message);
                    }

                  return false;
                 }
                 if (rs.rows.length > 0) {
                    for (var i = 0; i < rs.rows.length; ++i) {
                        var row = rs.rows.item(i);
                        channels.push(
                            {name: row.name, channel_id: row.channel_id, type: row.type}
                        );
                    }
                } else {
                    console.debug("Storage: No values for channels. Table existed?", tableExisted);
                }
             }
         )
         return channels;
     }

     function cleanTable(table) {
         __db().transaction(
             function(tx) {
                 __ensureTables(tx);
                 try {
                    var rs = tx.executeSql('DELETE FROM ' + table);
                 }
                 catch(e) {
                    console.log('DB error in cleanTable function')
                    if(e.code === SQLException.DATABASE_ERR) {
                        console.warn('Database error:', e.message);
                    } else if(e.code === SQLException.SYNTAX_ERR) {
                        console.warn('Database syntax error:', e.message);
                    } else {
                        console.warn('Database unknown error:', e.message);
                    }

                    return false;
                }
             }
         )
         return true;
     }

//     function addItem(name, channel_id, type) {
//              __db().transaction(
//                  function(tx) {
//                      __ensureTables(tx);
//                      tx.executeSql("INSERT INTO channels VALUES(?, ?, ?)", [name, channel_id, type]);
//                      fillModel();
//                  }
//              )
//          }
     function saveChannel(name, channel_id, type) {
              __db().transaction(
                  function(tx) {
                      __ensureTables(tx);
                      tx.executeSql("INSERT OR REPLACE INTO channels VALUES(?, ?, ?)", [name, channel_id, type]);
                  }
              )
          }
     function deleteChannel( name) {
              __db().transaction(
                  function(tx) {
                      tx.executeSql("DELETE FROM channels WHERE name=?", [name]);
                  }
              )
          }
     function saveChannels(channels) {
         if(!cleanTable('channels')) {
            return false;
         }
         for (var i = 0; i < channels.length; ++i) {
            var channel = channels[i];
            saveChannel(channel.name, channel.channel_id, channel.type);
         }
         return true;
     }


//     Component.onCompleted: {
//         fillModel();
//     }
 }
