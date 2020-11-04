import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_parking/controller/logic_manager.dart';
import 'package:just_parking/controller/parking_spot_manager.dart';
import 'package:just_parking/controller/reservationcommand.dart';
import 'package:just_parking/model/parkingspot.dart';

class CancelReservationCommand implements ReservationCommand {
  @override
  Future<void> execute(LogicManager manager,
      ParkingSpotManager parkingSpotManager, String uid) async {
    parkingSpotManager.getParkingSpot().setReservedBy(null);
    parkingSpotManager.getParkingSpot().setStatus(ParkingSpot.AVAILABLE);
    await Firestore.instance
        .collection('parkingSpots')
        .document(parkingSpotManager.getParkingSpot().getUID())
        .updateData(parkingSpotManager.serializeParkingSpotInfo());
    Firestore.instance
        .collection('parkingSpots')
        .document(uid)
        .updateData({'lastReserveTime': DateTime(1)});
  }
}
