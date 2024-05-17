class Stack<E> {
  final List<E> _list = [];

  void push(E element) {
    _list.add(element);
  }

  E pop() {
    if (_list.isEmpty) {
      throw StateError('No element to pop');
    }
    return _list.removeLast();
  }

  E peek() {
    if (_list.isEmpty) {
      throw StateError('No element to peek');
    }
    return _list.last;
  }

  bool get isEmpty => _list.isEmpty;

  void clear() {
    _list.clear();
  }

  List<E> toList() => List.unmodifiable(_list);
}
