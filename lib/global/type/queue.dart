class Queue<E> {
  final List<E> _list = [];

  void enqueue(E element) {
    _list.add(element);
  }

  E dequeue() {
    if (_list.isEmpty) {
      throw StateError('No element to dequeue');
    }
    return _list.removeAt(0);
  }

  E peek() {
    if (_list.isEmpty) {
      throw StateError('No element to peek');
    }
    return _list.first;
  }

  bool get isEmpty => _list.isEmpty;

  void clear() {
    _list.clear();
  }

  List<E> toList() => List.unmodifiable(_list);
}
