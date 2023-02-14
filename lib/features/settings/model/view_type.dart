enum ViewType {
  grid,
  list,
  detailed;

  ViewType toggle() {
    return ViewType.values[(index + 1) % ViewType.values.length];
  }
}
