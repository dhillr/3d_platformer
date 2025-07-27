static class convert {
 static byte[] intToBytes(int value, int numBytes) {
    byte[] res = new byte[numBytes];
    int total = value;
    
    for (int i = 0; i < numBytes; i++) {
      int weight = (int)pow(256, numBytes - 1 - i);
      if (total - weight >= 0) {
        res[i] = (byte)(total / weight);
        total -= weight;
      } else {
        res[i] = 0;
      }
    }
    
    return res;
  }
  
  static int bytesToInt(byte[] bytes, int numBytes) {
    int res = 0;
    for (int i = 0; i < numBytes; i++) {
      int weight = (int)pow(256, numBytes - 1 - i);
      res += (bytes[i] & 255) * weight;
    }
    
    return res;
  }
}
