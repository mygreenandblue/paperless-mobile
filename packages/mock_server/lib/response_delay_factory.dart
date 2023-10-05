import 'dart:math';

abstract interface class ResponseDelayFactory {
  Duration nextDelay();
}

class RandomResponseDelayFactory implements ResponseDelayFactory {
  /// Minimum allowed response delay
  final Duration minDelay;

  /// Maximum allowed response delay
  final Duration maxDelay;

  final Random _random = Random();
  RandomResponseDelayFactory(this.minDelay, this.maxDelay);

  @override
  Duration nextDelay() {
    return Duration(
      milliseconds: minDelay.inMilliseconds +
          _random.nextInt(
            maxDelay.inMilliseconds - minDelay.inMilliseconds,
          ),
    );
  }
}

class ConstantResponseDelayFactory implements ResponseDelayFactory {
  final Duration delay;

  const ConstantResponseDelayFactory(this.delay);

  @override
  Duration nextDelay() {
    return delay;
  }
}

class ZeroResponseDelayFactory implements ResponseDelayFactory {
  const ZeroResponseDelayFactory();

  @override
  Duration nextDelay() {
    return Duration.zero;
  }
}
