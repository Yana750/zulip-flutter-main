class CurrentChannel {
  static int? streamId;

  static void set(int id) {
    streamId = id;
  }

  static int? get() => streamId;
}
