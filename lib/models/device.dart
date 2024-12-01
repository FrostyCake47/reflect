class Device{
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String publicKey;
  final String encryptedKey;

  Device({required this.deviceId, required this.deviceName, required this.deviceType, required this.publicKey, required this.encryptedKey});

  Map<String, dynamic> toMap(){
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'publicKey': publicKey,
      'encryptedKey': encryptedKey
    };
  }

  factory Device.fromMap(Map<String, dynamic> map){
    return Device(
      deviceId: map['deviceId'],
      deviceName: map['deviceName'],
      deviceType: map['deviceType'],
      publicKey: map['publicKey'],
      encryptedKey: map['encryptedKey']
    );
  }
}