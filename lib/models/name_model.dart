class Name {
  final int id;
  final String femaleName;
  int isFavorite;
  int isWatched;

  Name({
    this.id,
    this.femaleName,
    this.isFavorite,
    this.isWatched,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'femaleName': femaleName,
      'isFavorite': isFavorite,
      'isWatched': isWatched
    };
  }
}
