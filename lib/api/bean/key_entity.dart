class KeyEntity<K, V> {
  K code;
  V label;

  KeyEntity({this.code, this.label});

  KeyEntity.set(this.code, this.label);

}
