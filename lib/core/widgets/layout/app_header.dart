import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    this.brand = 'InventaPro',
    this.location = 'Principal',
    this.locations = const ['Principal'],
    this.onLocationChanged,
    this.avatarImage,
    this.avatarInitials = 'JP',
    this.onAvatarTap,
    this.onLogoTap,
    this.logo,
    super.key,
  });

  final String brand;
  final String location;
  final List<String> locations;
  final ValueChanged<String>? onLocationChanged;
  final ImageProvider<Object>? avatarImage;
  final String avatarInitials;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLogoTap;
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            return Row(
              children: [
                InkWell(
                  onTap: onLogoTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      logo ??
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(
                              Icons.layers_rounded,
                              color: colors.onPrimary,
                              size: 20,
                            ),
                          ),
                      if (!compact) ...[
                        const SizedBox(width: 9),
                        Text(
                          brand,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                if (locations.isNotEmpty)
                  PopupMenuButton<String>(
                    initialValue: location,
                    onSelected: onLocationChanged,
                    tooltip: 'Seleccionar sucursal',
                    itemBuilder: (context) => locations
                        .map(
                          (item) => PopupMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: compact ? 130 : 156,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest.withValues(
                          alpha: 0.55,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colors.outlineVariant.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: 15,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.expand_more_rounded, size: 17),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                Semantics(
                  button: onAvatarTap != null,
                  label: 'Perfil de usuario',
                  child: InkWell(
                    onTap: onAvatarTap,
                    customBorder: const CircleBorder(),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: colors.primaryContainer,
                      foregroundImage: avatarImage,
                      child: avatarImage == null
                          ? Text(
                              avatarInitials,
                              style: TextStyle(
                                color: colors.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
