class Notifier<T> {
  final List<void Function(T)> _subscribers = [];

  void subscribe(void Function(T) listener) {
    _subscribers.add(listener);
  }

  void unsubscribe(void Function(T) listener) {
    _subscribers.remove(listener);
  }

  void notify(T event) {
    for (var subscriber in _subscribers) {
      subscriber(event);
    }
  }
}
