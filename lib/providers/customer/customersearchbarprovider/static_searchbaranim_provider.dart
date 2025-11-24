import 'package:flutter/material.dart';
import 'dart:async';

class StaticSearchBarAnimProvider extends ChangeNotifier {
  int _currentServiceIndex = 0;
  int _currentCharIndex = 0;
  Timer? _rotationTimer;
  bool _isTyping = true;
  String _displayText = '';

  final List<String> _services = [
    'Plumbing',
    'Cleaning',
    'Painting',
    'Repairing',
    'Electrical',
    'Appliance',
    'Moving',
    'Handyman',
  ];

  String get currentService => _displayText;
  String get fullCurrentService => _services[_currentServiceIndex];
  List<String> get services => _services;
  int get currentServiceIndex => _currentServiceIndex;

  void startServiceRotation() {
    _rotationTimer?.cancel();
    _startTypewriterEffect();
  }

  void _startTypewriterEffect() {
    _rotationTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_isTyping) {
        if (_currentCharIndex < _services[_currentServiceIndex].length) {
          _displayText = _services[_currentServiceIndex].substring(
            0,
            _currentCharIndex + 1,
          );
          _currentCharIndex++;
          notifyListeners();
        } else {
          timer.cancel();
          Timer(const Duration(milliseconds: 1000), () {
            _isTyping = false;
            _currentCharIndex = _services[_currentServiceIndex].length;
            _startDeletingEffect();
          });
        }
      }
    });
  }

  void _startDeletingEffect() {
    _rotationTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!_isTyping) {
        if (_currentCharIndex > 0) {
          _currentCharIndex--;
          _displayText = _services[_currentServiceIndex].substring(
            0,
            _currentCharIndex,
          );
          notifyListeners();
        } else {
          timer.cancel();
          _currentServiceIndex = (_currentServiceIndex + 1) % _services.length;
          _isTyping = true;
          _currentCharIndex = 0;
          _displayText = '';

          Timer(const Duration(milliseconds: 150), () {
            _startTypewriterEffect();
          });
        }
      }
    });
  }

  void stopServiceRotation() {
    _rotationTimer?.cancel();
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }
}
