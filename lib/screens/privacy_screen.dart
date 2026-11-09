import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Privacy & Data Security Screen based on docs/08_SECURITY_PRIVACY.md
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Shield Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.18),
                    AppTheme.accentCyan.withOpacity(0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderHighlight.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, size: 44, color: AppTheme.primaryLight),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zero AI Model Training',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your selfies are processed in-memory solely to render your preview. They are NEVER retained to train or fine-tune AI models.',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'StyleMirror Core Commitments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),

            _buildCommitmentCard(
              icon: Icons.timer_outlined,
              title: '24-Hour Automated Purge',
              description:
                  'Every photo upload and every generated preview has a strict 24-hour Time-To-Live (TTL). Once expired, files and database records are permanently deleted by automated background cleanups.',
            ),
            const SizedBox(height: 12),

            _buildCommitmentCard(
              icon: Icons.delete_sweep_outlined,
              title: 'Instant Manual Wipe',
              description:
                  'You never have to wait 24 hours. The "Delete My Photo Now" button immediately purges your photo and all generated assets with one tap.',
            ),
            const SizedBox(height: 12),

            _buildCommitmentCard(
              icon: Icons.lock_outline,
              title: 'End-to-End Encryption',
              description:
                  'All API communication is encrypted over HTTPS. Internal file paths are accessed using time-limited signed authorization tokens.',
            ),
            const SizedBox(height: 12),

            _buildCommitmentCard(
              icon: Icons.vpn_key_outlined,
              title: 'Zero Client-Side Secret Leakage',
              description:
                  'AI provider keys live strictly in protected server environments. No client app or mobile binary ever bundles or transmits API keys.',
            ),
            const SizedBox(height: 28),

            // Legal & Regulatory Alignment
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Regulatory Compliance',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Compliant with Digital Personal Data Protection (DPDP) and GDPR principles for biometric data processing: explicit consent, purpose limitation, storage limitation, and right to erasure.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: AppTheme.accentCyan),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
