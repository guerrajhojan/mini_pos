import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({
    required this.child,
    this.eyebrow,
    this.title,
    this.subtitle,
    this.headerActions,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 28),
    this.maxWidth = 1100,
    super.key,
  });

  final Widget child;
  final String? eyebrow;
  final String? title;
  final String? subtitle;
  final List<Widget>? headerActions;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (eyebrow != null) ...[
                Text(
                  eyebrow!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              if (title != null || headerActions != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ...?headerActions,
                  ],
                ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
