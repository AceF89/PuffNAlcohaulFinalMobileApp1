class Utils {
  static String getDisplayAddress(
      String? address, String? googleAddress, String? address2) {
    if (address == null || googleAddress == null || address2 == null) {
      return '';
    }
    int index = googleAddress.indexOf(address);

    if (index != -1) {
      String beforeAddress = googleAddress.substring(0, index + address.length);
      String afterAddress = googleAddress.substring(index + address.length);

      return '$beforeAddress, $address2$afterAddress';
    }

    return googleAddress;
  }
}
