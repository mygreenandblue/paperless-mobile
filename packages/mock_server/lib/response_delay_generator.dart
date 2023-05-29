import 'dart:math';

abstract interface class DelayGenerator {
  Duration nextDelay();
}

class RandomDelayGenerator implements DelayGenerator {
  /// Minimum allowed response delay
  final Duration minDelay;

  /// Maximum allowed response delay
  final Duration maxDelay;

  final Random _random = Random();
  RandomDelayGenerator(this.minDelay, this.maxDelay);

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

class ConstantDelayGenerator implements DelayGenerator {
  final Duration delay;

  const ConstantDelayGenerator(this.delay);

  @override
  Duration nextDelay() {
    return delay;
  }
}

class ZeroDelayGenerator implements DelayGenerator {
  const ZeroDelayGenerator();

  @override
  Duration nextDelay() {
    return Duration.zero;
  }
}
