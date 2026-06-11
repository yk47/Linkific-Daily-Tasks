import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class OverflowScreen extends StatefulWidget {
  const OverflowScreen({super.key});

  @override
  State<OverflowScreen> createState() => _OverflowScreenState();
}

class _OverflowScreenState extends State<OverflowScreen> {
  bool showFixedVersion = false;

  final String longText =
      'This is an extremely long text designed to demonstrate how a '
      'RenderFlex overflow occurs when widgets try to occupy more space '
      'than is available on the screen width.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar('Layout Overflow'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoCard(
            text: 'Toggle between broken and fixed layouts. The broken version '
                'triggers the classic RenderFlex overflow error.',
            icon: Icons.open_in_full_rounded,
            accentColor: AppColors.warning,
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: SwitchListTile(
              title: Text(
                showFixedVersion ? '✅  Fixed Layout' : '❌  Broken Layout',
                style: TextStyle(
                  color: showFixedVersion ? AppColors.success : AppColors.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                showFixedVersion
                    ? 'Using Expanded + TextOverflow.ellipsis'
                    : 'Raw Row with unconstrained Text',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
              value: showFixedVersion,
              onChanged: (v) => setState(() => showFixedVersion = v),
            ),
          ),
          const SizedBox(height: 16),

          // Demo area
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: showFixedVersion
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: showFixedVersion
                        ? AppColors.successDim
                        : AppColors.errorDim,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        showFixedVersion
                            ? Icons.check_circle_rounded
                            : Icons.error_outline_rounded,
                        color: showFixedVersion
                            ? AppColors.success
                            : AppColors.error,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        showFixedVersion ? 'Fixed Example' : 'Broken Example',
                        style: TextStyle(
                          color: showFixedVersion
                              ? AppColors.success
                              : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: showFixedVersion
                      ? _buildFixed()
                      : _buildBroken(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SectionCard(
            title: 'How to Fix Overflow',
            icon: Icons.construction_rounded,
            accentColor: AppColors.warning,
            child: Column(
              children: const [
                _FixRow(code: 'Expanded', desc: 'Takes remaining flex space'),
                _FixRow(code: 'Flexible', desc: 'Flexible sizing in Row/Column'),
                _FixRow(code: 'TextOverflow.ellipsis', desc: 'Truncate overflowing text'),
                _FixRow(code: 'SingleChildScrollView', desc: 'Make content scrollable'),
                _FixRow(code: 'Widget Inspector', desc: 'Visualize layout constraints'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBroken() {
    return Row(
      children: [
        const Icon(Icons.warning_rounded, size: 36, color: AppColors.error),
        const SizedBox(width: 10),
        Text(longText, style: const TextStyle(color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildFixed() {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 36,
          color: AppColors.success,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            longText,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _FixRow extends StatelessWidget {
  final String code;
  final String desc;
  const _FixRow({required this.code, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.warningDim,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}