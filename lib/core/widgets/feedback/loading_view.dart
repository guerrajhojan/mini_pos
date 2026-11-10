import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    this.message = 'Cargando...',
    this.indicatorSize = 36,
    super.key,
  });

  final String message;
  final double indicatorSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: indicatorSize,
            child: const CircularProgressIndicator(),
          ),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
