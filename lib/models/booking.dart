
class Booking{
  final id;
  final facilityId;
  final startDate;
  final endDate;
  final bookingCost;
  final facilityName;
  final facilityPhotoPath;
  final creationDate;
  final userId;

  Booking({
    this.startDate,
    this.endDate,
    this.id,
    this.facilityId,
    this.bookingCost,
    this.facilityName,
    this.facilityPhotoPath,
    this.creationDate,
    this.userId
});
}