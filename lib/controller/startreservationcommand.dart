import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_parking/controller/logic_manager.dart';
import 'package:just_parking/controller/parking_spot_manager.dart';
import 'package:just_parking/controller/reservationcommand.dart';
import 'package:just_parking/model/parkingspot.dart';

class StartReservationCommand implements ReservationCommand {
  @override
  static Future<void> execute(LogicManager manager,
      ParkingSpotManager parkingSpotManager, String uid) async {
    var snapshot =
        await Firestore.instance.collection('parkingSpots').document(uid).get();

    //ParkingSpotManager manager = ParkingSpotManager();
    parkingSpotManager.deserializeParkingSpotInfo(snapshot.data);
    parkingSpotManager.getParkingSpot().setStatus(ParkingSpot.HOLD);

    parkingSpotManager
        .getParkingSpot()
        .setReservedBy(manager.getUser().getUID());

    var ref = Firestore.instance
        .collection('parkingSpots')
        .document(parkingSpotManager.getParkingSpot().getUID());
    await Firestore.instance.runTransaction((transaction) async {
      return transaction.get(ref).then((doc) async {
        if (doc.data['reservedBy'] == null) {
          transaction.update(
              ref, parkingSpotManager.serializeParkingSpotInfo());
        } else {
          throw Exception("already reserved");
        }
      });
    });

     Firestore.instance
        .collection('parkingSpots')
        .document(uid)
        .updateData({'lastReserveTime': DateTime.now()});
  }

  /*



  */

}
